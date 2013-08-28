Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3H1VWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:22:34 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56615 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3H1VWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <1377714003-22096-1-git-send-email-robherring2@gmail.com>
References: <1377714003-22096-1-git-send-email-robherring2@gmail.com>
From: Julien Grall <julien.grall@linaro.org>
Date: Wed, 28 Aug 2013 22:22:02 +0100
Message-ID: <CAPnVf8xczxPDucWMPcJ-Rre9uBXWAtHA0NkT62xu5ZghvpsFRg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: xen: only set pm function ptrs for Xen guests
To: Rob Herring <robherring2@gmail.com>
Cc: xen-devel@lists.xensource.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2013 19:20, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> xen_pm_init was unconditionally setting pm_power_off and arm_pm_restart
> function pointers. This breaks multi-platform kernels. Make this
> conditional on running as a Xen guest and make it a late_initcall to
> ensure it is setup after platform code for Dom0.
>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  arch/arm/xen/enlighten.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 8a6295c..13a7d1f 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -273,12 +273,15 @@ core_initcall(xen_guest_init);
>
>  static int __init xen_pm_init(void)
>  {
> +       if (!of_find_compatible_node(NULL, NULL, "xen,xen"))
> +               return -ENODEV;
> +

You should use the macro xen_domain() to check if we are running
in a Xen guest.

Cheers,

-- 
Julien Grall
