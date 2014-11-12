Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaKLPQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:16:12 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:60648 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaKLPQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:16:11 -0500
MIME-Version: 1.0
In-Reply-To: <20141112150651.GF21343@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
	<alpine.DEB.2.11.1411012313320.5308@nanos>
	<alpine.DEB.2.11.1411061057470.5591@gentwo.org>
	<CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
	<20141110153147.GK4901@linux.vnet.ibm.com>
	<alpine.DEB.2.11.1411101226310.12918@gentwo.org>
	<20141111171526.GC3216@lerouge>
	<CAKohpok3U_8zQurs219fOmwERFrnZ0sOE-YUc7B+fKYfFLmEpg@mail.gmail.com>
	<20141112135455.GA6895@lerouge>
	<CAKohpo=U7K==YMytwcGwteTXdf1RFdxo8BoDhfR-9AriL83D8Q@mail.gmail.com>
	<20141112150651.GF21343@twins.programming.kicks-ass.net>
Date: Wed, 12 Nov 2014 20:46:10 +0530
Message-ID: <CAKohpompt7Gizq2GRVsCkoGvsZxKzBM_FWjzGaNjkdSu=aM__Q@mail.gmail.com>
Subject: Re: Future of NOHZ full/isolation development (was Re: [NOHZ] Remove scheduler_tick_max_deferment)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 20:36, Peter Zijlstra <peterz@infradead.org> wrote:
> I don't think you need to add anything. We already have tracepoints for
> every single interrupt (and therefore also for the hrtimer one) and we
> have expiry tracepoints.

I will crosscheck this again but as far as I remember these spurious interrupts
aren't caught with tracers currently. Not even the irq_enter/exit ones.

I saw that piece of code long back (and obviously don't understand it
completely). But the problem was that because these are spurious
clockevent interrupts, we don't have anything to do on that interrupt.
No tick/sched/softirq processing. And the irq-handling code returns before
even calling trace_irq_enter().

And that's why I had to add those prints initially.
