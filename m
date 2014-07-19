Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbaGSSq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 14:46:59 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:65271 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbaGSSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 14:46:58 -0400
Date: Sat, 19 Jul 2014 14:46:56 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
In-Reply-To: <20140719183132.GK3935@laptop>
Message-ID: <alpine.LFD.2.11.1407191442100.3647@knanqh.ubzr>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com> <1405730661-9355-8-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.11.1407191318320.3647@knanqh.ubzr> <20140719183132.GK3935@laptop>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014, Peter Zijlstra wrote:

> On Sat, Jul 19, 2014 at 01:31:25PM -0400, Nicolas Pitre wrote:
> > On Sat, 19 Jul 2014, Frederic Weisbecker wrote:
> > 
> > > The timekeeper gets initialized to the value of the CPU where the
> > > first clockevent device is setup. This works well because the timekeeper
> > > can be any online CPU in most configs.
> > > 
> > > Full dynticks has its own requirement though and needs the timekeeper
> > > to always be 0. And this requirement seem to accomodate pretty well with
> > > the above described boot timekeeper setting because the first clockevent
> > > device happens to be initialized, most of the time, on the boot CPU
> > > (which should be CPU 0).
> > 
> > This might have been discussed before... but this isn't ARM big.LITTLE 
> > friendly at all.
> > 
> > Could we accommodate for any arbitrary CPU instead of making CPU 0 
> > "special" other than its role as the boot CPU please?  It doesn't have 
> > to be completely dynamic, but CPU 0 might be a really bad choice for 
> > ongoing periodic duties in some configurations.  For example, we might 
> > highly prefer to do this on CPU 4 for power efficiency reasons once it 
> > is online and keep CPU 0 in a deep C-state as much as possible.
> 
> This is because CPU0 can be a big core, right? IIRC this is done because
> a big core as boot cpu, boots faster and some people think boot time is
> relevant.

People think all sorts of things.  And it becomes very irritating when 
thoughtful assumptions get burned into ROM for example.  We should be 
able to do better in the kernel.


Nicolas
