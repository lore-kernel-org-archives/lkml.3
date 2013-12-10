Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3LJInD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:43:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab3LJInA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:43:00 -0500
Date: Tue, 10 Dec 2013 08:42:57 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Drew Jones <drjones@redhat.com>
Subject: Re: [PATCH 17/18] sched: Tracepoint task movement
Message-ID: <20131210084257.GD11295@suse.de>
References: <1386572952-1191-1-git-send-email-mgorman@suse.de>
 <1386572952-1191-18-git-send-email-mgorman@suse.de>
 <52A611FB.7000305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <52A611FB.7000305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 01:54:51PM -0500, Rik van Riel wrote:
> On 12/09/2013 02:09 AM, Mel Gorman wrote:
> > move_task() is called from move_one_task and move_tasks and is an
> > approximation of load balancer activity. We should be able to track
> > tasks that move between CPUs frequently. If the tracepoint included node
> > information then we could distinguish between in-node and between-node
> > traffic for load balancer decisions. The tracepoint allows us to track
> > local migrations, remote migrations and average task migrations.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Does this replicate the task_sched_migrate_task tracepoint in
> set_task_cpu() ?
> 

There is significant overlap but bits missing. We do not necessarily know
where the task was previously running and whether this is a local->remote
migration. We also cannot tell the difference between load balancer activity,
numa balancing and try_to_wake_up. Still, you're right, this patch is not
painting a full picture either. I'll drop it for now and look at improving
the existing task_sched_migrate_task tracepoint.

-- 
Mel Gorman
SUSE Labs
