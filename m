Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaLNS0C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:26:02 -0500
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:41058 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750753AbaLNS0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:26:00 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4362:5007:6261:7875:7903:8660:8957:9040:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12663:12740:13069:13148:13230:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sofa67_5149dc640454d
X-Filterd-Recvd-Size: 2035
Date: Sun, 14 Dec 2014 13:25:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214132556.6f8d6fb9@gandalf.local.home>
In-Reply-To: <20141214181835.GG5310@linux.vnet.ibm.com>
References: <20141214164104.307127356@goodmis.org>
	<20141214164803.991954802@goodmis.org>
	<20141214115332.76be1b8b@gandalf.local.home>
	<20141214180854.GC5310@linux.vnet.ibm.com>
	<20141214131538.7a6c1438@gandalf.local.home>
	<20141214181835.GG5310@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 10:18:35 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > With your feed back, and because I would like this to go into 3.19, I
> > would like to keep the current patch as is (with the read_mostly
> > update, which I'm currently testing). We can always change it later
> > after call_rcu() has been changed.
> 
> Completely agreed!  ;-)

For this late in the game, we need to play it safe.

I got rid of my tracepoint patch and moved trace_init() to after
rcu_init(), which I think is good enough for Thomas. Thomas?

I'll start testing that now.

Later, if you could add a rcu_init() version that lets us call
call_rcu_sched() just after mm_init() then we could move trace_init()
up a bit more.

Thanks,

-- Steve
