Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaGSSbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 14:31:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:48955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaGSSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 14:31:36 -0400
Date: Sat, 19 Jul 2014 20:31:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
Message-ID: <20140719183132.GK3935@laptop>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-8-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.11.1407191318320.3647@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1407191318320.3647@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 01:31:25PM -0400, Nicolas Pitre wrote:
> On Sat, 19 Jul 2014, Frederic Weisbecker wrote:
> 
> > The timekeeper gets initialized to the value of the CPU where the
> > first clockevent device is setup. This works well because the timekeeper
> > can be any online CPU in most configs.
> > 
> > Full dynticks has its own requirement though and needs the timekeeper
> > to always be 0. And this requirement seem to accomodate pretty well with
> > the above described boot timekeeper setting because the first clockevent
> > device happens to be initialized, most of the time, on the boot CPU
> > (which should be CPU 0).
> 
> This might have been discussed before... but this isn't ARM big.LITTLE 
> friendly at all.
> 
> Could we accommodate for any arbitrary CPU instead of making CPU 0 
> "special" other than its role as the boot CPU please?  It doesn't have 
> to be completely dynamic, but CPU 0 might be a really bad choice for 
> ongoing periodic duties in some configurations.  For example, we might 
> highly prefer to do this on CPU 4 for power efficiency reasons once it 
> is online and keep CPU 0 in a deep C-state as much as possible.

This is because CPU0 can be a big core, right? IIRC this is done because
a big core as boot cpu, boots faster and some people think boot time is
relevant.
