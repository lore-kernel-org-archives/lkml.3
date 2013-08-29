Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3H2NK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:10:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50345 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3H2NK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:10:56 -0400
X-IronPort-AV: E=Sophos;i="4.89,983,1367971200"; 
   d="scan'208";a="46395606"
Date: Thu, 29 Aug 2013 14:10:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rob Herring <robherring2@gmail.com>
CC: <xen-devel@lists.xensource.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <julien.grall@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v3] ARM: xen: only set pm function ptrs for Xen guests
In-Reply-To: <1377780232-13545-1-git-send-email-robherring2@gmail.com>
Message-ID: <alpine.DEB.2.02.1308291409470.6397@kaball.uk.xensource.com>
References: <1377780232-13545-1-git-send-email-robherring2@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> xen_pm_init was unconditionally setting pm_power_off and arm_pm_restart
> function pointers. This breaks multi-platform kernels. Make this
> conditional on running as a Xen guest and make it a late_initcall to
> ensure it is setup after platform code for Dom0.
> 
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Added to my queue.


>  arch/arm/xen/enlighten.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 8a6295c..7071fca 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -273,12 +273,15 @@ core_initcall(xen_guest_init);
>  
>  static int __init xen_pm_init(void)
>  {
> +	if (!xen_domain())
> +		return -ENODEV;
> +
>  	pm_power_off = xen_power_off;
>  	arm_pm_restart = xen_restart;
>  
>  	return 0;
>  }
> -subsys_initcall(xen_pm_init);
> +late_initcall(xen_pm_init);
>  
>  static irqreturn_t xen_arm_callback(int irq, void *arg)
>  {
> -- 
> 1.8.1.2
> 
