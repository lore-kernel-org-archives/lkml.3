Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaLPLUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:20:55 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:48241 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLPLUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:20:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, horms@verge.net.au, geert@linux-m68k.org,
        tglx@linutronix.de
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Date: Tue, 16 Dec 2014 13:20:56 +0200
Message-ID: <1418731028.WfBPmyK53y@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54901420.50403@linaro.org>
References: <20141216094854.22639.69181.sendpatchset@w520> <54901420.50403@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tuesday 16 December 2014 12:14:40 Daniel Lezcano wrote:
> On 12/16/2014 10:48 AM, Magnus Damm wrote:
> > From: Magnus Damm <damm+renesas@opensource.se>
> > 
> > Update the TMU driver to use cpu_possible_mask as cpumask to make
> > r8a7779 SMP work as expected with or without the ARM TWD timer.
> > 
> > Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
> 
> Applied as a 3.18 fix.

You're a bit too fast, I haven't had time to review the patch yet.

> ps: May I suggest to use the CLOCK_EVT_FEAT_DYNIRQ flag for this driver ?
> 
> > ---
> > 
> >   drivers/clocksource/sh_tmu.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- 0001/drivers/clocksource/sh_tmu.c
> > +++ work/drivers/clocksource/sh_tmu.c	2014-12-16 17:49:49.000000000 +0900
> > @@ -428,7 +428,7 @@ static void sh_tmu_register_clockevent(s
> > 
> >   	ced->features = CLOCK_EVT_FEAT_PERIODIC;
> >   	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
> >   	ced->rating = 200;
> > -	ced->cpumask = cpumask_of(0);
> > +	ced->cpumask = cpu_possible_mask;

Magnus, how thoroughly have you tested this ? The TMU is indeed usable by all 
CPUs, so setting the CPU mask to cpu_possible_mask makes sense, but last time 
I've tried that it broke the broadcast timer due to the heuristics used by the 
clock events core code.

Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and 
CONFIG_PREEMPT with and without the ARM TWD times, and that you've booted to 
userspace and tested timer broadcast on all CPUs ?

> >   	ced->set_next_event = sh_tmu_clock_event_next;
> >   	ced->set_mode = sh_tmu_clock_event_mode;
> >   	ced->suspend = sh_tmu_clock_event_suspend;

-- 
Regards,

Laurent Pinchart

