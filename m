Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaLHPI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:08:56 -0500
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:36485 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755661AbaLHPIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:08:55 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3874:4250:5007:6261:7556:7875:10004:10400:10848:10967:11232:11658:11914:12296:12517:12519:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shirt83_3082013c7703a
X-Filterd-Recvd-Size: 1620
Date: Mon, 8 Dec 2014 10:08:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: [GIT PULL] tracing/NMI/printk: Use seq_buf for safe printing
 from NMI context
Message-ID: <20141208100851.3906cc0a@gandalf.local.home>
In-Reply-To: <20141208100528.5f97106f@gandalf.local.home>
References: <20141208100528.5f97106f@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014 10:05:28 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> This code solves the issue of performing stack dumps from NMI context.
> The issue is that printk() is not safe from NMI context as if the NMI
> were to trigger when a printk() was being performed, the NMI could
> deadlock from the printk() internal locks. This has been seen in practice.
> 

One added bonus is that this code also makes the NMI dump stack work on
PREEMPT_RT kernels. As printk() includes sleeping locks on PREEMPT_RT,
printk() only writes to console if the console does not use any
rt_mutex converted spin locks. Which a lot do.

-- Steve
