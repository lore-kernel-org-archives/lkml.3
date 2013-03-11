Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3CKWuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:50:10 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:18967 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994Ab3CKWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:50:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18aRNX42tjVntj1u9oYT4hq
Date: Mon, 11 Mar 2013 15:50:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
Message-ID: <20130311225004.GR26093@atomide.com>
References: <20130308180730.GE11806@atomide.com>
 <513A2B20.30805@codeaurora.org>
 <20130308194802.GG11806@atomide.com>
 <513A40EF.8050403@codeaurora.org>
 <20130308200811.GJ11806@atomide.com>
 <513A4774.3040605@codeaurora.org>
 <20130308202947.GK11806@atomide.com>
 <513A8B22.5030008@codeaurora.org>
 <20130311172847.GP26093@atomide.com>
 <513E5804.3050104@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E5804.3050104@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Boyd <sboyd@codeaurora.org> [130311 15:22]:
> On 03/11/13 10:28, Tony Lindgren wrote:
> > * Stephen Boyd <sboyd@codeaurora.org> [130308 17:10]:
> >> On 03/08/13 12:29, Tony Lindgren wrote:
> >>> Applying that does not seem to help, but you might want to get vexpress
> >>> running anyways for some multiplatform sanity checks.
> >>>
> >>> I just built and installed qemu-linaro from their git, then ran the
> >>> command above. Looks like stock qemu does not work for vexpress for some
> >>> reason. You can probably use a dummy initrd and rootfs to debug this
> >>> though :)
> >> So my patchset didn't break qemu?
> > Sorry if that was unclear: Yes your patchset breaks booting vexpress
> > in qemu.
> >
> >
> 
> Ok. qemu works for me before applying my patches. I've added this into
> the series before this patch to fix the boot issue.

OK thanks:

Acked-by: Tony Lindgren <tony@atomide.com>

 
> -----8<-----
> 
> Subject: [PATCH] ARM: vexpress: Move smp_twd setup to time_late_init hook
> 
> On devices without a clock describing the rate of the twd we
> detect the rate at runtime via twd_calibrate_rate(). Currently
> this happens when smp_prepare_cpus() calls the localtimer start
> callback, after the sp804 timer has been registered and when
> jiffies have started incrementing.
> 
> In the next patch we're going to make twd_local_timer_register()
> register the twd clockevent on the boot CPU. In the case of
> vexpress, this will hang the system at boot because jiffies
> haven't started incrementing when twd_calibrate_rate() is called.
> Register the smp_twd during time_late_init() on vexpress to avoid
> this problem.
> 
> Based on a patch by Marc Zyngier <marc.zyngier@arm.com>.
> 
> Reported-by: Tony Lindgren <tony@atomide.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-vexpress/ct-ca9x4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
> index 6f34497..a9f39bf 100644
> --- a/arch/arm/mach-vexpress/ct-ca9x4.c
> +++ b/arch/arm/mach-vexpress/ct-ca9x4.c
> @@ -62,7 +62,7 @@ static void __init ct_ca9x4_init_irq(void)
>  {
>  	gic_init(0, 29, ioremap(A9_MPCORE_GIC_DIST, SZ_4K),
>  		 ioremap(A9_MPCORE_GIC_CPU, SZ_256));
> -	ca9x4_twd_init();
> +	late_time_init = ca9x4_twd_init;
>  }
>  
>  static int ct_ca9x4_clcd_setup(struct clcd_fb *fb)
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
