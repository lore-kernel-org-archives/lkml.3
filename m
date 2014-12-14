Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaLNRoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:44:37 -0500
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:51454 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751297AbaLNRod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:44:33 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:5007:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knot71_a7e3ed772326
X-Filterd-Recvd-Size: 2415
Date: Sun, 14 Dec 2014 12:44:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214124431.48689d64@gandalf.local.home>
In-Reply-To: <759389895.27358.1418578168225.JavaMail.zimbra@efficios.com>
References: <20141214164104.307127356@goodmis.org>
	<20141214164803.991954802@goodmis.org>
	<1556965801.27338.1418576749817.JavaMail.zimbra@efficios.com>
	<20141214121457.59b22354@gandalf.local.home>
	<20141214122136.1664e104@gandalf.local.home>
	<759389895.27358.1418578168225.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 17:29:28 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Given that your reason for having this RCU-specific logic in tracepoint.c
> rather than within call_rcu*() is not slowing down a fast-path, how about
> creating a new call_rcu_early() and call_rcu_sched_early() which can be
> called in normal operation and at early boot ?

That's a possibility.

> 
> This would allow us to keep the RCU logic within the RCU implementation
> rather than strongly coupling it with the tracepoint code.
> 

It's not that strong of a coupling to RCU. It's more coupled to being
called really early (which needs special care).

It just happened that RCU failed for being called that early. Other
things could possible fail too (if added to the tracepoint logic).
Maybe I should rename the variable to "tracepoint_earlyboot" instead.

But as RCU is the only thing that failed (so far in my testing), I'll
think about adding a call_rcu_sched_early(). But then, this does make
things more complex, and me more nervous about adding it.

-- Steve
