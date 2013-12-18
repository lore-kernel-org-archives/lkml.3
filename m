Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3LRKGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:06:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41960 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3LRKG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:06:28 -0500
Date: Wed, 18 Dec 2013 11:06:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 07/13] sched: Enable IPI reception on timekeeper under
 nohz full system
Message-ID: <20131218100615.GN13532@twins.programming.kicks-ass.net>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-8-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-8-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:26PM +0100, Frederic Weisbecker wrote:
> We need the default timekeeping CPU to be able to receive IPIs sent
> from full dynticks CPUs when they wake up from full system idle state.
> 
> Therefore we need an entrypoint from the scheduler IPI so that the
> need to poll on timekeeping duty is re-evaluated from irq_exit().
> 
> In order to achieve this, lets take the scheduler IPI everytime as long
> as there is at least one full dynticks CPU around. Full dynticks CPUs
> are interested too in taking scheduler IPIs to reevaluate their tick.

I should probably read the other patches in this series, but the above
makes my brain go *beeeep* and throw an error.


