Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab3IDIhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:37:35 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:33151 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab3IDIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:37:31 -0400
Date: Wed, 4 Sep 2013 17:37:29 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        sboyd@codeaurora.org, rob.herring@calxeda.com, olof@lixom.net,
        santosh.shilimkar@ti.com, grant.likely@linaro.org, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: em_sti: Set cpu_possible_mask to fix SMP
 broadcast
Message-ID: <20130904083727.GE17329@verge.net.au>
References: <20130904080151.24562.91334.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904080151.24562.91334.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Droped johnstultz@linaro.org CC, the address seems to bounce
  Added Daniel Lezcano CC, I believe he handles clocksource these days ]

On Wed, Sep 04, 2013 at 05:01:51PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Update the STI driver by setting cpu_possible_mask to make EMEV2
> SMP work as expected together with the ARM broadcast timer.
> 
> This breakage was introduced by:
> 
> f7db706 ARM: 7674/1: smp: Avoid dummy clockevent being preferred over real hardware clock-event
> 
> Without this fix SMP operation is broken on EMEV2 since no
> broadcast timer interrupts trigger on the secondary CPU cores.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Tested-by: Simon Horman <horms+renesas@verge.net.au>

I will let this sit for a few days to see if there is any further feedback.

> ---
> 
>  Thanks to feedback from Stephen Boyd this is is a reworked version of:
>  [PATCH] clocksource: em_sti: Adjust clock event rating to fix SMP broadcast
> 
>  drivers/clocksource/em_sti.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 0001/drivers/clocksource/em_sti.c
> +++ work/drivers/clocksource/em_sti.c	2013-09-04 16:51:42.000000000 +0900
> @@ -301,7 +301,7 @@ static void em_sti_register_clockevent(s
>  	ced->name = dev_name(&p->pdev->dev);
>  	ced->features = CLOCK_EVT_FEAT_ONESHOT;
>  	ced->rating = 200;
> -	ced->cpumask = cpumask_of(0);
> +	ced->cpumask = cpu_possible_mask;
>  	ced->set_next_event = em_sti_clock_event_next;
>  	ced->set_mode = em_sti_clock_event_mode;
>  
> 
