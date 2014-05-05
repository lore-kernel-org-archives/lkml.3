Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaEEXd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:33:56 -0400
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:59950 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932931AbaEEXdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:33:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:69:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4321:4837:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12291:12296:12517:12519:12683:12740:13069:13255:13311:13357:13868,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fruit94_79297c3765506
X-Filterd-Recvd-Size: 1753
Message-ID: <1399332831.27516.6.camel@joe-AO725>
Subject: Re: [PATCH] printk: Remove separate printk_sched buffers and use
 printk buf instead
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, pmladek@suse.cz,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 05 May 2014 16:33:51 -0700
In-Reply-To: <20140505191846.35aa6f9b@gandalf.local.home>
References: <20140505191846.35aa6f9b@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 19:18 -0400, Steven Rostedt wrote:
> To prevent deadlocks with doing a printk inside the scheduler,
> printk_sched() was created. The issue is that printk has a console_sem
> that it can grab and release. The release does a wake up if there's a
> task pending on the sem, and this wake up grabs the rq locks that is
> held in the scheduler. This leads to a possible deadlock if the wake up
> uses the same rq as the one with the rq lock held already.
[]
>  kernel/printk/printk.c |   87 +++++++++++++++++++++++++++++++------------------
[]
> @@ -2440,18 +2470,20 @@
>  #define PRINTK_BUF_SIZE		512

Wouldn't this define be unused and shouldn't it be deleted too?


