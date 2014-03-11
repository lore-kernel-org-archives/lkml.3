Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaCKJ01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:26:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46224 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaCKJ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:26:24 -0400
Date: Tue, 11 Mar 2014 10:26:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/16] kernel/sys: Replace opened code implementation
 with nice_to_rlimit().
Message-ID: <20140311092608.GT9987@twins.programming.kicks-ass.net>
References: <cover.1394529373.git.yangds.fnst@cn.fujitsu.com>
 <23d8f4c6d70b34d29b5f69e30b19cfb920889ede.1394529373.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23d8f4c6d70b34d29b5f69e30b19cfb920889ede.1394529373.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 05:20:23PM +0800, Dongsheng Yang wrote:
> From: Joe Perches <joe@perches.com>
> 
> Convert 20 - task_nice(p) to nice_to_rlimit(task_nice(p)).
> 
> Reduce the indent the switch case labels while there.
> 
> git diff -w shows 3 lines changed and a /* fall-through */ comment added
> 
>   $ git diff -w -U0 kernel/sys.c
>   @@ -253 +253 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>   -                               niceval = 20 - task_nice(p);
>   +                       niceval = nice_to_rlimit(task_nice(p));
>   @@ -264 +264 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>   -                               niceval = 20 - task_nice(p);
>   +                       niceval = nice_to_rlimit(task_nice(p));
>   @@ -280 +280 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
>   -                                       niceval = 20 - task_nice(p);
>   +                               niceval = nice_to_rlimit(task_nice(p));
>   @@ -1558 +1558 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>   -
>   +               /* fall-through */
> 

I would really like to see the whitespace changes separated. I can push
a scheduler related change into other subsystems, but massive surgery
like this should not come through the scheduler tree.


