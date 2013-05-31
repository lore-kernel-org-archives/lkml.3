Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab3EaFdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:33:09 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:42120 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3EaFdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:33:00 -0400
Date: Fri, 31 May 2013 08:32:47 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Dinh Nguyen <dinguyen@altera.com>,
        Jamie Iles <jamie@jamieiles.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/2] clocksource: dw_apb: allow build for
 architectures other than arm
Message-ID: <20130531053247.GX5037@tarshish>
References: <1369570367-994-2-git-send-email-baruch@tkos.co.il>
 <51A51271.2070506@linaro.org>
 <20130530053233.GL25186@sapphire.tkos.co.il>
 <51A77A25.8080306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A77A25.8080306@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, May 30, 2013 at 09:11:17AM -0700, John Stultz wrote:
> On 05/29/2013 10:32 PM, Baruch Siach wrote:
> >On Tue, May 28, 2013 at 01:24:17PM -0700, John Stultz wrote:
> >>On 05/26/2013 05:12 AM, Baruch Siach wrote:
> >>>  static const struct of_device_id osctimer_ids[] __initconst = {
> >>>@@ -124,3 +135,10 @@ void __init dw_apb_timer_init(void)
> >>>  	init_sched_clock();
> >>>  }
> >>>+
> >>>+#ifndef CONFIG_HAVE_SETUP_SCHED_CLOCK
> >>>+unsigned long long notrace sched_clock()
> >>>+{
> >>>+	return read_sched_clock() * sched_clock_mult;
> >>>+}
> >>>+#endif
> >>Also, can you try to condense the number of #ifndef
> >>CONFIG_HAVE_SETUP_SCHED_CLOCK checks to one, and consolidate the
> >>needed functions all in that one conditional?
> >Thanks for your comments. I'll rework the patch and resubmit.
> >
> >I've just noticed that I have a bigger problem. read_sched_clock() returns
> >u32, not u64. This means that in a rate of, say, 100MHz it will wrap around
> >after a little more than 40 seconds. Would it make sense to put ARM's 32 bin
> >sched_clock extension code (arch/arm/kernel/sched_clock.c) is a common place
> >(maybe drivers/clocksource), and use that? There seems to be nothing ARM
> >specific in this code, after all.
> 
> Yea, working out an actual generic sched_clock implementation is
> something I'd like to see done.
> 
> Though I'd really rather we not toss yet another chunk of
> infrastructure in the drivers/clocksource directory. Instead we
> should probably have a kernel/time/sched_clock.c.
> 
> Then its just the issue of tying that and the clocksource code
> together so you just register existing capable clocksources with a
> SCHED_CLOCK flag or via a different registration hook.
> 
> I don't think it will be an easy job, but if you want to give it a
> shot, I'd be quite interested in reviewing the patches!

Although I'd very much like to contribute in this area, I'm afraid I don't 
have time for this now. My problem is much narrower in scope, though, and I 
think it can be solved without a generic sched_clock implementation at first 
step. All I want is to use a 32 bit counter for sched_clock. The code enabling 
this is currently only available for ARM (arch/arm/kernel/sched_clock.c). 
Should this part of the code move to kernel/time/sched_clock.c?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
