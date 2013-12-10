Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3LJOsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:48:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50732 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3LJOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:48:10 -0500
Date: Tue, 10 Dec 2013 15:47:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com
Subject: Re: [RFC][PATCH 0/7] sched: Optimize sched_clock bits
Message-ID: <20131210144744.GN3694@twins.programming.kicks-ass.net>
References: <20131129173657.252094369@infradead.org>
 <529B7B27.4070801@linux.intel.com>
 <20131203151053.GD8070@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203151053.GD8070@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:10:53PM +0100, Peter Zijlstra wrote:
> Also, static_key and related APIs suck donkey ballz -- I did indeed
> promise myself I'd not step into that bike shed contest but having had
> to use them again *painfull*.

> POST:
> 
> [    5.061000] sched_clock_stable: 1
> [   18.916000] (cold) sched_clock: 1335206
> [   32.576000] (cold) local_clock: 1365236
> [   32.580000] (warm) sched_clock: 11771
> [   32.584000] (warm) local_clock: 14725

It looks like this was using the jiffies (tsc_disabled) instead of rdtsc path.

/me curses static_key and co more.
