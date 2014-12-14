Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaLNRVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:21:42 -0500
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:34832 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190AbaLNRVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:21:40 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:5007:6261:7875:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tax35_65ac21a82be61
X-Filterd-Recvd-Size: 1712
Date: Sun, 14 Dec 2014 12:21:36 -0500
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
Message-ID: <20141214122136.1664e104@gandalf.local.home>
In-Reply-To: <20141214121457.59b22354@gandalf.local.home>
References: <20141214164104.307127356@goodmis.org>
	<20141214164803.991954802@goodmis.org>
	<1556965801.27338.1418576749817.JavaMail.zimbra@efficios.com>
	<20141214121457.59b22354@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 12:14:57 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> If IRQ setup, or other core pieces of code can use this, then I would
> agree that rcu should be changed. But until then, I rather not add
> another conditional to the core RCU code.

Also, call_rcu*() is called from several hot paths. This location is
not a hot path, and actually, it is in fact rather slow. That's another
reason not to add the logic into the RCU code if just adding it to
tracepoints is sufficient.

-- Steve
