Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaGSRb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 13:31:28 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:47095 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaGSRb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 13:31:27 -0400
Date: Sat, 19 Jul 2014 13:31:25 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
In-Reply-To: <1405730661-9355-8-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.LFD.2.11.1407191318320.3647@knanqh.ubzr>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com> <1405730661-9355-8-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014, Frederic Weisbecker wrote:

> The timekeeper gets initialized to the value of the CPU where the
> first clockevent device is setup. This works well because the timekeeper
> can be any online CPU in most configs.
> 
> Full dynticks has its own requirement though and needs the timekeeper
> to always be 0. And this requirement seem to accomodate pretty well with
> the above described boot timekeeper setting because the first clockevent
> device happens to be initialized, most of the time, on the boot CPU
> (which should be CPU 0).

This might have been discussed before... but this isn't ARM big.LITTLE 
friendly at all.

Could we accommodate for any arbitrary CPU instead of making CPU 0 
"special" other than its role as the boot CPU please?  It doesn't have 
to be completely dynamic, but CPU 0 might be a really bad choice for 
ongoing periodic duties in some configurations.  For example, we might 
highly prefer to do this on CPU 4 for power efficiency reasons once it 
is online and keep CPU 0 in a deep C-state as much as possible.


Nicolas
