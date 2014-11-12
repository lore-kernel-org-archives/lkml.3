Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaKLQ4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:56:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:45177 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaKLQ4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:56:17 -0500
Date: Wed, 12 Nov 2014 17:56:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112165610.GO29390@twins.programming.kicks-ass.net>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
 <20141112122155.GA3250@redhat.com>
 <20141112125158.GB21343@twins.programming.kicks-ass.net>
 <20141112155843.GA24803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112155843.GA24803@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 04:58:44PM +0100, Stanislaw Gruszka wrote:
> Commit d670ec13178d0 "posix-cpu-timers: Cure SMP wobbles" fixes one glibc
> test case in cost of breaking another one. After that commit, calling
> clock_nanosleep(TIMER_ABSTIME, X) and then clock_gettime(&Y) can result
> of Y time being smaller than X time.
> 
> Below is full reproducer (tst-cpuclock2.c) :
> 
> /* Parameters for the Linux kernel ABI for CPU clocks.  */
>         ((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
> 

You lost all the #include and #define stmts there, restored them from
the previous posting.
