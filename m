Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaJ0MV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:21:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60248 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJ0MVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:21:55 -0400
Date: Mon, 27 Oct 2014 13:21:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Burke Libbey <burke.libbey@shopify.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH] sched: Fix race between task_group and sched_task_group
Message-ID: <20141027122146.GC3337@twins.programming.kicks-ass.net>
References: <1414405105.19914.169.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414405105.19914.169.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:18:25PM +0400, Kirill Tkhai wrote:
> 
> The race may happen when somebody is changing task_group of a forking task.
> Child's cgroup is the same as parent's after dup_task_struct() (there just
> memory copying). Also, cfs_rq and rt_rq are the same as parent's.
> 
> But if parent changes its task_group before it's called cgroup_post_fork(),
> we do not reflect this situation on child. Child's cfs_rq and rt_rq remain
> the same, while child's task_group changes in cgroup_post_fork().
> 
> To fix this we introduce fork() method, which calls sched_move_task() directly.
> This function changes sched_task_group on appropriate (also its logic has
> no problem with freshly created tasks, so we shouldn't introduce something
> special; we are able just to use it).

Right, I read some of that cgroup.c stuff and this is indeed possible,
yucky. Applied, thanks!
