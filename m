Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab3INBSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 21:18:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46492 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755650Ab3INBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 21:18:30 -0400
Date: Fri, 13 Sep 2013 21:18:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] Introduce timekeeper latch synchronization
Message-ID: <20130914011825.GA24859@Krystal>
References: <20130913025253.GA17218@Krystal> <20130913153020.GA24383@Krystal> <52336576.1060908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52336576.1060908@linaro.org>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* John Stultz (john.stultz@linaro.org) wrote:
> On 09/13/2013 08:30 AM, Mathieu Desnoyers wrote:
> > By the way, if there are some standard test-bench for timekeeping, I'd
> > be very interested to hear about them.
> I've got a git repo of tests that I use for basic sanity checks here:
>     https://github.com/johnstultz-work/timetests.git

Thanks for the pointer! It looks like I'm currently breaking
CLOCK_MONOTONIC_RAW. My thoughts are that struct clocksource read vs
updates are relying on the timekeeper seqlock for synchronization.
Therefore, I might have to apply the latch scheme to struct clocksource
too.

Thoughts ?

Thanks,

Mathieu

> 
> thanks
> -john
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
