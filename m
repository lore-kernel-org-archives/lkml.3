Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaFFPnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:43:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFFPnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:43:07 -0400
Date: Fri, 6 Jun 2014 17:43:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@kernel.org
Subject: Re: [PATCH] sched,numa: ensure task_numa_migrate checks the
 preferred node
Message-ID: <20140606154301.GD11371@laptop.programming.kicks-ass.net>
References: <20140604160942.6969b101@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604160942.6969b101@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:09:42PM -0400, Rik van Riel wrote:
> The first thing task_numa_migrate does is check to see if there is
> CPU capacity available on the preferred node, in order to move the
> task there.
> 
> However, if the preferred node is all busy, we would skip considering
> that node for tasks swaps in the subsequent loop. This prevents NUMA
> convergence of tasks on busy systems.
> 
> However, swapping locations with a task on our preferred nid, when
> the preferred nid is busy, is perfectly fine.
> 
> The fix is to also look for a CPU on our preferred nid when it is
> totally busy.
> 
> This changes "perf bench numa mem -p 4 -t 20 -m -0 -P 1000" from
> not converging in 15 minutes on my 4 node system, to converging in
> 10-20 seconds.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>


Indeed so. Thanks Rik!

