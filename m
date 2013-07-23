Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3GWJfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:35:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37316 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab3GWJfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:35:50 -0400
Date: Tue, 23 Jul 2013 10:35:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Julien Grall <julien.grall@linaro.org>
Cc: "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] xen/arm64: Don't compile cpu hotplug
Message-ID: <20130723093513.GC4833@e106331-lin.cambridge.arm.com>
References: <1374529258-12866-1-git-send-email-julien.grall@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374529258-12866-1-git-send-email-julien.grall@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 10:40:58PM +0100, Julien Grall wrote:
> On ARM64, when CONFIG_XEN=y, the compilation will fail because CPU hotplug is
> not yet supported with XEN. For now, disable it.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>

With this applied I'm able to build an arm64 kernel with both
CONFIG_HOTPLUG_CPU (from local patches) and CONFIG_XEN.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Cheers,
Mark.

> ---
>  drivers/xen/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 2bf461a..a609353 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,4 +1,4 @@
> -ifneq ($(CONFIG_ARM),y)
> +ifeq ($(filter y, $(CONFIG_ARM) $(CONFIG_ARM64)),)
>  obj-y	+= manage.o
>  obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
>  endif
> -- 
> 1.7.10.4
> 
> 
