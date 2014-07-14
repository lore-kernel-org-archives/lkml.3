Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaGNMja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:39:30 -0400
Received: from mail.efficios.com ([78.47.125.74]:47941 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbaGNMjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:39:25 -0400
Date: Mon, 14 Jul 2014 12:39:26 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Message-ID: <1154261133.13906.1405341566164.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140714094750.GO9918@twins.programming.kicks-ass.net>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de> <20140714094750.GO9918@twins.programming.kicks-ass.net>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
Thread-Index: BfeNE5gAcsbYb1pJr1Ukc0rO90/9Qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Peter Zijlstra" <peterz@infradead.org>
> To: "Thomas Gleixner" <tglx@linutronix.de>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "John Stultz" <john.stultz@linaro.org>, "Steven Rostedt"
> <rostedt@goodmis.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Sent: Monday, July 14, 2014 5:47:50 AM
> Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
> 
> On Fri, Jul 11, 2014 at 01:45:19PM -0000, Thomas Gleixner wrote:
> > +static struct tk_fast tk_fast_raw  ____cacheline_aligned;
> > +static struct tk_fast tk_fast_mono ____cacheline_aligned;
> 
> Question to the 'trace maniacs'; why do you lot need access to mono_raw?
> 
> I would much prefer to limit choice here.

For LTTng, which I guess qualifies as bring part of the aforementioned
trace maniacs group, we only need the "tk_fast_mono" clock. We don't
need mono_raw.

We can then correlate with user-space traces by using tk_fast_mono in
kernel-space and using CLOCK_MONOTONIC in userspace.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
