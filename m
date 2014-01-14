Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaANKF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:05:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56223 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaANKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:05:55 -0500
Date: Tue, 14 Jan 2014 11:05:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marian Marinov <mm@yuhu.biz>
Cc: lxc-devel@lists.linuxcontainers.org, cgroups@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Li Zefan <lizefan@huawei.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: cgroups aware proc
Message-ID: <20140114100541.GS7572@laptop.programming.kicks-ass.net>
References: <52D35CD0.9070602@huawei.com>
 <52D41316.5080508@yuhu.biz>
 <20140113171238.GS31570@twins.programming.kicks-ass.net>
 <52D48BA6.2080701@yuhu.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D48BA6.2080701@yuhu.biz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:58:14AM +0200, Marian Marinov wrote:
> On 01/13/2014 07:12 PM, Peter Zijlstra wrote:
> >On Mon, Jan 13, 2014 at 06:23:50PM +0200, Marian Marinov wrote:
> >>Hello Peter,
> >>
> >>I need help with the scheduler.
> >>
> >>I'm currently trying to patch the /proc/loadavg to show the load that is
> >>only related to the processes from the current cgroup.
> >>
> >>I looked trough the code and I was hoping that tsk->sched_task_group->cfs_rq
> >>struct will give me the needed information, but unfortunately for me, it did
> >>not.
> >>
> >>Can you advise me, how to approach this problem?
> >
> >Yeah, don't :-) Really, loadavg is a stupid metric.
> 
> Yes... stupid, but unfortunately everyone is looking at it :(
> 
> >
> >>I'm totally new to the scheduler code.
> >
> >Luckily you won't actually have to touch much of it. Most of the actual
> >loadavg code lives in the first ~400 lines of kernel/sched/proc.c, read
> >and weep. Its one of the best documented bits around.
> 
> I looked trough it but I don't understand how to introduce the per cgroup calculation.
> 
> I looked trough the headers and found the following, which is already implemented.
> 
>   task->sched_task_group->load_avg
>   task->sched_task_group->cfs_rq->load_avg
>   task->sched_task_group->cfs_rq->load.weight
>   task->sched_task_group->cfs_rq->runnable_load_avg
> 
> Unfortunately there is almost no documentation for these elements of the cfs_rq and task_group structs.
> 
> It seams to me that part of the per task group loadavg code is already present.

No, those are actual load metrics and completely unrelated to loadavg.

Loadavg requires per-cgroup-per-cpu variants of nr_running and
nr_uninterruptible.

Those are the only metrics used in kernel/sched/proc.c for loadavg.
