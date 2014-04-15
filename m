Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaDOP1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:27:32 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:50565 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDOP1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:27:31 -0400
Date: Tue, 15 Apr 2014 11:27:28 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle
 info
In-Reply-To: <20140415132510.GO11182@twins.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.11.1404151111470.980@knanqh.ubzr>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <22904760.5rGZuP5nsx@vostro.rjw.lan> <alpine.LFD.2.11.1404012141580.1571@knanqh.ubzr> <1930679.LtC4HPqI3x@vostro.rjw.lan> <20140415132510.GO11182@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Peter Zijlstra wrote:

> On Fri, Apr 04, 2014 at 01:43:00PM +0200, Rafael J. Wysocki wrote:
> > > That's what this patch series is about.  The find_idlest_cpu code should 
> > > look for the idle CPU with the shallowest idle state, or the one with 
> > > the smallest load.  In this context "find_idlest_cpu" might become a 
> > > misnomer.
> > 
> > Yes, clearly.  It should be called find_best_cpu or something like that.
> 
> Ha!, but for what purpose? We already have find_busiest_cpu() to find
> the CPU to steal work from. The converse action, currently called
> find_idlest_cpu() is finding the CPU where to put work.
> 
> 'Best' is ambiguous in all regards, it doesn't convey the direction nor
> the quality sorted on.
> 
> So while idlest might be somewhat of a misnomer, it at least conveys the
> directional thing fairly well. Also we are still searching the least
> busy, and preferable an idle, cpu. 'Idlest' being a superlative also
> conveys the meaning of order.

I agree that anything which is called "best" is ambigous.  Best for 
what?  That isn't self explanatory.

However "idlest" is no longer the wanted attribute here.  "Least busy" 
is right.  But not necessarily the "idlest".  The "best" CPU here is 
somewhat in the middle between busiest and idlest i.e. preferably idle, 
but not the "idlest" in the cpuidle sense.

Maybe we could use your definition to simply call it 
find_cpu_to_put_work() or the like.  Today this is based on the idleness 
of CPUs, but eventually we'll want to pack tasks on already loaded CPUs 
(without oversubscribing them) in order to keep as many CPUs idle as 
possible when that makes sense, which would alter the selection 
somewhat.


Nicolas
