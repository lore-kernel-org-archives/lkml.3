Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaBNOVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:21:20 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:41482 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaBNOVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:21:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 26/27] ARM: shmobile: lager-reference: Enable CMT0 in device tree
Date: Fri, 14 Feb 2014 15:22:22 +0100
Message-ID: <2354725.yUCM3gQqXi@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <52FE2498.8040609@cogentembedded.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <2244047.l1cecWDdMU@avalon> <52FE2498.8040609@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Friday 14 February 2014 18:13:44 Sergei Shtylyov wrote:
> On 14-02-2014 17:48, Laurent Pinchart wrote:
> >>> Enable the CMT0 device and configure channel 0 as a clock event
> >>> provider.
> >>> 
> >>> Signed-off-by: Laurent Pinchart
> >>> <laurent.pinchart+renesas@ideasonboard.com>
> >>> 
> >>> diff --git a/arch/arm/mach-shmobile/include/mach/r8a7790.h
> >>> b/arch/arm/mach-shmobile/include/mach/r8a7790.h index 0b95bab..62b31f3
> >>> 100644 --- a/arch/arm/mach-shmobile/include/mach/r8a7790.h
> >>> +++ b/arch/arm/mach-shmobile/include/mach/r8a7790.h
> >>> @@ -29,7 +29,6 @@ enum {
> >>>  };
> >>>   
> >>>  void r8a7790_add_standard_devices(void);
> >>> -void r8a7790_add_dt_devices(void);
> >>>  void r8a7790_clock_init(void);
> >>>  void r8a7790_pinmux_init(void);
> >>>  void r8a7790_pm_init(void);
> >>> diff --git a/arch/arm/mach-shmobile/setup-r8a7790.c
> >>> b/arch/arm/mach-shmobile/setup-r8a7790.c index 3e5813f..462c81f 100644
> >>> --- a/arch/arm/mach-shmobile/setup-r8a7790.c
> >>> +++ b/arch/arm/mach-shmobile/setup-r8a7790.c
> >>> @@ -294,11 +294,6 @@ static struct resource cmt0_resources[] = {
> >>>    					  &cmt##idx##_platform_data,	\
> >>>    					  sizeof(struct sh_timer_config))
> >>> 
> >>> -void __init r8a7790_add_dt_devices(void)
> >>> -{
> >>> -	r8a7790_register_cmt(0);
> >>> -}
> >>> -
> >>>  void __init r8a7790_add_standard_devices(void)
> >>>  {
> >>>    	r8a7790_register_scif(0);
> >>> @@ -311,7 +306,7 @@ void __init r8a7790_add_standard_devices(void)
> >>>    	r8a7790_register_scif(7);
> >>>    	r8a7790_register_scif(8);
> >>>    	r8a7790_register_scif(9);
> >>> -	r8a7790_add_dt_devices();
> >>> +	r8a7790_register_cmt(0);
> >>>    	r8a7790_register_irqc(0);
> >>>    	r8a7790_register_thermal();
> >>>  }
> >>>   
> >> IMHO, these 2 files should be split into a separate patch.
> > 
> > That could easily be done, but why ?
> 
> It does not seem necessary to combine these changes in one patch. Remember,
> Simon has separate branches for boards and SoCs. So finally it's up to him
> to decide on this...

Right, but in this case I need to remove the CMT platform device registration 
from r8a7790_add_dt_devices() at the same time as I enable it in DT, otherwise 
we'll have two instances of the same device.

-- 
Regards,

Laurent Pinchart

