Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3HTPfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:35:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64322 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3HTPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:35:30 -0400
Date: Tue, 20 Aug 2013 17:35:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130820153524.GC17441@somewhere>
References: <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130819111026.GE24092@twins.programming.kicks-ass.net>
 <521313D8.9080500@lab.ntt.co.jp>
 <20130820084405.GC3258@twins.programming.kicks-ass.net>
 <20130820152910.GB17441@somewhere>
 <52138C5E.4060705@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52138C5E.4060705@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:33:50AM -0700, Arjan van de Ven wrote:
> On 8/20/2013 8:29 AM, Frederic Weisbecker wrote:
> 
> >>
> >>Of course, if we can get away with completely removing all of that
> >>(which I think Arjan suggested was a real possibility) then that would
> >>be ever so much better still :-)
> >
> >Would be lovely. But I don't know much about cpufreq, I hope somebody who's
> >familiar with that code can handle this. Then once there are no more users
> >of get_cpu_iowait_sleep_time() I can simply zap and clean the tick/time related
> >code.
> 
> it's just doing the "idle = 100 - busy% - iowait%" calculation.
> (with the later part only for Intel cpus iirc)
> 
> in a perfect world the scheduler would be doing that calculation in the first place ;-)
> 
> removing the later part will impact performance some on specific workloads,
> but most Intel cpus that this applies to should not be using cpufreq anymore
> anyway.

Are there other users than intel?
