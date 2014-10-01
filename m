Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaJANfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:35:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42455 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaJANfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:35:30 -0400
Date: Wed, 1 Oct 2014 15:35:27 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: dinguyen@opensource.altera.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH 1/2] socfpga: hotplug: put cpu1 in wfi
Message-ID: <20141001133527.GA12750@amd>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com>
 <1411590449-9794-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411590449-9794-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Alan Tull <atull@opensource.altera.com>
> 
> Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
> since that results in increased power consumption.
> 
> Reset CPU1 briefly during CPU1 bootup.
> 
> This has been tested for hotplug and suspend/resume and results
> in no increased power consumption.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>  arch/arm/mach-socfpga/core.h    |    2 ++
>  arch/arm/mach-socfpga/platsmp.c |   12 +++++++++---
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-socfpga/core.h b/arch/arm/mach-socfpga/core.h
> index 572b8f7..c4a0929 100644
> --- a/arch/arm/mach-socfpga/core.h
> +++ b/arch/arm/mach-socfpga/core.h
> @@ -28,6 +28,8 @@
>  #define RSTMGR_CTRL_SWCOLDRSTREQ	0x1	/* Cold Reset */
>  #define RSTMGR_CTRL_SWWARMRSTREQ	0x2	/* Warm Reset */
>  
> +#define RSTMGR_MPUMODRST_CPU1		0x2     /*CPU1 Reset*/
> +

It would be nice to have space after /* and before */.

> diff --git a/arch/arm/mach-socfpga/platsmp.c b/arch/arm/mach-socfpga/platsmp.c
> index 5356a72..1d5f8ad 100644
> --- a/arch/arm/mach-socfpga/platsmp.c
> +++ b/arch/arm/mach-socfpga/platsmp.c
> @@ -34,6 +34,10 @@ static int socfpga_boot_secondary(unsigned int cpu, struct task_struct *idle)
>  	int trampoline_size = &secondary_trampoline_end - &secondary_trampoline;
>  
>  	if (cpu1start_addr) {
> +		/* This will put CPU #1 into reset.*/

Same here.

> +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
> +			     rst_manager_base_addr + 0x10);

Would it be possible to copy reset manager description struct from
u-boot and use it here, instead of raw offset?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
