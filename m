Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbaDIRNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933686AbaDIRNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:13:07 -0400
Date: Wed, 9 Apr 2014 19:12:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
	for_each_thread()
Message-ID: <20140409171251.GD27638@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Frederic Weisbecker wrote:
>
> @@ -295,16 +295,15 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>  
>  	rcu_read_lock();
>  	/* make sure we can trust tsk->thread_group list */
> -	if (!likely(pid_alive(tsk)))
> +	if (!likely(pid_alive(p)))

You can simply remove this check now. for_each_thread() is always safe.

Oleg.

