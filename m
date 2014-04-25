Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaDYJKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:10:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaDYJKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:10:02 -0400
Date: Fri, 25 Apr 2014 10:09:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        chegu_vinod@hp.com
Subject: Re: [PATCH 3/3] sched,numa: do not set preferred_node on migration
 to a second choice node
Message-ID: <20140425090959.GC23991@suse.de>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
 <1397235629-16328-4-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1397235629-16328-4-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:00:29PM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Setting the numa_preferred_node for a task in task_numa_migrate
> does nothing on a 2-node system. Either we migrate to the node
> that already was our preferred node, or we stay where we were.
> 
> On a 4-node system, it can slightly decrease overhead, by not
> calling the NUMA code as much. Since every node tends to be
> directly connected to every other node, running on the wrong
> node for a while does not do much damage.
> 

Guess what size of machine I do the vast bulk of testing of automatic
NUMA balancing on!

> However, on an 8 node system, there are far more bad nodes
> than there are good ones, and pretending that a second choice
> is actually the preferred node can greatly delay, or even
> prevent, a workload from converging.
> 
> The only time we can safely pretend that a second choice
> node is the preferred node is when the task is part of a
> workload that spans multiple NUMA nodes.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Tested-by: Vinod Chegu <chegu_vinod@hp.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
