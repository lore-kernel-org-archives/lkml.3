Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaBKMYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:24:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:50014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKMYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:24:15 -0500
Message-ID: <1392121442.4128.14.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC - beta][PATCH] tracing: Introduce TRACE_MARKER() no
 argument trace event
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfgang Grandegger <wg@grandegger.com>
Date: Tue, 11 Feb 2014 13:24:02 +0100
In-Reply-To: <20140207152814.16e263ab@gandalf.local.home>
References: <20140207112357.35552998@gandalf.local.home>
	 <20140207152814.16e263ab@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 15:28 -0500, Steven Rostedt wrote:

> I'm thinking no. And unless someone can give me a good reason that we
> should have such a thing, I will Nack my own patch!

:)

> What's up with trace_iwlwifi_dev_irq()?  You are tracing it but not
> saving any information. There's obviously a reason for the
> iwl_pcie_isr() to be called (it's handling something). Does it do the
> exact same thing every time?  No variables are needed then?
> 
> What I'm trying to say is, if you go through the trouble of inserting a
> tracepoint into some location, might as well extract data from it.
> Otherwise you are wasting space in memory. If all you want to know is
> if the function was called or not, then simply use a kprobe or function
> trace that function (noinline to allow ftrace to trace it).

I think right now the tracepoint is misplaced, I meant it to be in the
function that's now iwl_pcie_isr() but I guess I haven't used it much.

In any case, the reasoning was that we don't yet know any useful data,
we really only know that an interrupt happened. We later have this ICT
(interrupt cause table or something) that we read the information from,
but for tracing I want to know each field in the table even though only
the OR of all of them is later relevant.

So originally we had "interrupt" and then "interrupt reason"
tracepoints. Looking at the code now, that seems to have been lost, so I
guess I should instead add the reason to the tracepoint and only have
the ICT tracing separate when ICT is enabled (in fact, if ICT isn't
enabled, I don't have the reason status at all...)


Looking at this I'd agree that having a special 'hit only' trace event
isn't really needed (any more), at least not for this particular case.

johannes

