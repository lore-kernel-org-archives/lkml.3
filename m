Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3KSHSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:18:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61041 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3KSHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:18:07 -0500
Date: Tue, 19 Nov 2013 08:17:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, pjt@google.com, akpm@linux-foundation.org,
        tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
        lwoodman@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Optimize task_sched_runtime()
Message-ID: <20131119071757.GA32478@gmail.com>
References: <20131111172925.GG26898@twins.programming.kicks-ass.net>
 <tip-911b2898b3c9fe0048e9485ad1629ed4fce330fd@git.kernel.org>
 <1384831002.2459.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384831002.2459.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Wed, 2013-11-13 at 09:25 -0800, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  911b2898b3c9fe0048e9485ad1629ed4fce330fd
> > Gitweb:     http://git.kernel.org/tip/911b2898b3c9fe0048e9485ad1629ed4fce330fd
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Mon, 11 Nov 2013 18:21:56 +0100
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 13 Nov 2013 13:33:54 +0100
> > 
> > sched: Optimize task_sched_runtime()
> > 
> > Large multi-threaded apps like to hit this using do_sys_times() and
> > then queue up on the rq->lock.
> > 
> > Avoid when possible.
> > 
> > Larry reported ~20% performance increase his test case.
> > 
> > Reported-by: Larry Woodman <lwoodman@redhat.com>
> > Suggested-by: Paul Turner <pjt@google.com>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Link: http://lkml.kernel.org/r/20131111172925.GG26898@twins.programming.kicks-ass.net
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> For what it's worth:
> 
> Tested-by: Davidlohr Bueso <davidlohr@hp.com>

Thanks for the testing - the change is upstream already and unless it 
causes regressions it will be part of the v3.13 kernel.

Thanks,

	Ingo
