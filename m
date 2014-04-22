Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaDVS0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:26:20 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47468 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaDVS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:26:19 -0400
Date: Tue, 22 Apr 2014 20:26:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Drew Richardson <drew.richardson@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Export sched tracepoints for use by kernel modules
Message-ID: <20140422182613.GA16359@gmail.com>
References: <20140422142313.GB21121@dreric01-Precision-T1600>
 <20140422144503.GA15892@gmail.com>
 <20140422145338.GA4591@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422145338.GA4591@dreric01-Precision-T1600>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Drew Richardson <drew.richardson@arm.com> wrote:

> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_sleep);
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_iowait);
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_blocked);
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stat_runtime);
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_pi_setprio);
> > > +#ifdef CONFIG_DETECT_HUNG_TASK
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_process_hang);
> > > +#endif /* CONFIG_DETECT_HUNG_TASK */
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_move_numa);
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_stick_numa);
> > > +EXPORT_TRACEPOINT_SYMBOL_GPL(sched_swap_numa);
> > 
> > Which in-tree kernel module is using these?
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> 
> Gator (http://git.linaro.org/arm/ds5/gator.git), an out of tree 
> kernel module, uses sched_process_fork, sched_switch and 
> sched_process_free. Along with exporting those tracepoints I thought 
> it would be helpful to export all the tracepoints from 
> trace/events/sched.h.

So, 'Gator' seems to be a rather ugly out of tree driver, ABI and 
daemon slapped on top of perf events, duplicating part of perf events 
functionality for no apparent good technical reason, just to enable a 
binary-only profiler called 'ARM Streamline Analyzer'.

What does the 'gator' driver offer that perf events does not offer in 
itself? If there's any sensible feature in there then it should be 
added to the mainline kernel not as an add on driver and filesystem, 
but as part of perf events subsystem itself.

Thanks,

	Ingo
