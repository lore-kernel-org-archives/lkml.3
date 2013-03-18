Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3CRJlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:41:46 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37951 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3CRJlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:41:45 -0400
Date: Mon, 18 Mar 2013 10:41:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST v3.9-rc1] sched: replace PF_THREAD_BOUND with
 PF_NO_SETAFFINITY
Message-ID: <20130318094140.GB25045@gmail.com>
References: <20130308204518.GR14556@mtj.dyndns.org>
 <20130314225508.GC9400@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314225508.GC9400@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> PF_THREAD_BOUND was originally used to mark kernel threads which were
> bound to a specific CPU using kthread_bind() and a task with the flag
> set allows cpus_allowed modifications only to itself.  Workqueue is
> currently abusing it to prevent userland from meddling with
> cpus_allowed of workqueue workers.
> 
> What we need is a flag to prevent userland from messing with
> cpus_allowed of certain kernel tasks.  In kernel, anyone can
> (incorrectly) squash the flag, and, for worker-type usages,
> restricting cpus_allowed modification to the task itself doesn't
> provide meaningful extra proection as other tasks can inject work
> items to the task anyway.
> 
> This patch replaces PF_THREAD_BOUND with PF_NO_SETAFFINITY.
> sched_setaffinity() checks the flag and return -EINVAL if set.
> set_cpus_allowed_ptr() is no longer affected by the flag.
> 
> This will allow simplifying workqueue worker CPU affinity management.

Acked-by: Ingo Molnar <mingo@kernel.org>

I suspect you want to carry this in the workqueue tree, to enable those 
extra simplifications?

Thanks,

	Ingo
