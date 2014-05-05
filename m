Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbaEEXzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:55:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:65460 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755309AbaEEXzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:55:16 -0400
Date: Mon, 5 May 2014 19:55:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, pmladek@suse.cz,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] printk: Remove separate printk_sched buffers and use
 printk buf instead
Message-ID: <20140505195513.6fcfe505@gandalf.local.home>
In-Reply-To: <1399332831.27516.6.camel@joe-AO725>
References: <20140505191846.35aa6f9b@gandalf.local.home>
	<1399332831.27516.6.camel@joe-AO725>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2014 16:33:51 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2014-05-05 at 19:18 -0400, Steven Rostedt wrote:
> > To prevent deadlocks with doing a printk inside the scheduler,
> > printk_sched() was created. The issue is that printk has a console_sem
> > that it can grab and release. The release does a wake up if there's a
> > task pending on the sem, and this wake up grabs the rq locks that is
> > held in the scheduler. This leads to a possible deadlock if the wake up
> > uses the same rq as the one with the rq lock held already.
> []
> >  kernel/printk/printk.c |   87 +++++++++++++++++++++++++++++++------------------
> []
> > @@ -2440,18 +2470,20 @@
> >  #define PRINTK_BUF_SIZE		512
> 
> Wouldn't this define be unused and shouldn't it be deleted too?
> 

I guess it would.

-- Steve
