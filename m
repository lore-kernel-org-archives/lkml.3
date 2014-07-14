Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaGNOPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:15:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:39951 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbaGNOPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:15:41 -0400
Date: Mon, 14 Jul 2014 16:15:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
In-Reply-To: <1154261133.13906.1405341566164.JavaMail.zimbra@efficios.com>
Message-ID: <alpine.DEB.2.10.1407141615130.24854@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de> <20140714094750.GO9918@twins.programming.kicks-ass.net> <1154261133.13906.1405341566164.JavaMail.zimbra@efficios.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Mathieu Desnoyers wrote:

> ----- Original Message -----
> > From: "Peter Zijlstra" <peterz@infradead.org>
> > To: "Thomas Gleixner" <tglx@linutronix.de>
> > Cc: "LKML" <linux-kernel@vger.kernel.org>, "John Stultz" <john.stultz@linaro.org>, "Steven Rostedt"
> > <rostedt@goodmis.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > Sent: Monday, July 14, 2014 5:47:50 AM
> > Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
> > 
> > On Fri, Jul 11, 2014 at 01:45:19PM -0000, Thomas Gleixner wrote:
> > > +static struct tk_fast tk_fast_raw  ____cacheline_aligned;
> > > +static struct tk_fast tk_fast_mono ____cacheline_aligned;
> > 
> > Question to the 'trace maniacs'; why do you lot need access to mono_raw?
> > 
> > I would much prefer to limit choice here.
> 
> For LTTng, which I guess qualifies as bring part of the aforementioned
> trace maniacs group, we only need the "tk_fast_mono" clock. We don't
> need mono_raw.
> 
> We can then correlate with user-space traces by using tk_fast_mono in
> kernel-space and using CLOCK_MONOTONIC in userspace.

I'm happy to ditch the raw one ...
