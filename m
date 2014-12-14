Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaLNRHg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:07:36 -0500
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:40456 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918AbaLNRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:07:35 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3292:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:5007:6261:7875:7903:9010:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12663:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crime99_7c36c98594363
X-Filterd-Recvd-Size: 2454
Date: Sun, 14 Dec 2014 12:07:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] tracing: Enable tracepoints early and allow printk
 to use them
Message-ID: <20141214120732.2503f6b0@gandalf.local.home>
In-Reply-To: <20141214164104.307127356@goodmis.org>
References: <20141214164104.307127356@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 11:41:04 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> As the merge window is still open, and this code was not as complex
> as I thought it might be. I'm thinking of pushing this in now.
> 
> This will allow Thomas to debug his irq work for 3.20.

Bah, my cover letters have sucked lately. Let me explain what this
patch set does.


It basically adds two new features.

1) Allow traceopoints to be enabled right after mm_init(). By passing
in the trace_event= kernel command line parameter, tracepoints can be
enabled at boot up. For debugging things like the initialization of
interrupts, it is needed to have tracepoints enabled very early. People
have asked about this before and this has been on my todo list. As it
can be helpful for Thomas to debug his upcoming 3.20 IRQ work, I'm
pushing this now. This way he can add tracepoints into the IRQ set up
and have have users enable them when things go wrong.

2) Have the tracepoints printed via printk() (the console) when they
are triggered. If the irq code locks up or reboots the box, having the
tracepoint output go into the kernel ring buffer is useless for
debugging. But being able to add the tp_printk kernel command line
option along with the trace_event= option will have these tracepoints
printed as they occur, and that can be really useful for debugging
early lock up or reboot problems.

-- Steve
