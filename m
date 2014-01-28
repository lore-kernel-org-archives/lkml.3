Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaA1J6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:58:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaA1J6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:58:32 -0500
Date: Tue, 28 Jan 2014 09:58:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 5/9] numa,sched,mm: use active_nodes nodemask to limit
 numa migrations
Message-ID: <20140128095828.GR4963@suse.de>
References: <1390860228-21539-1-git-send-email-riel@redhat.com>
 <1390860228-21539-6-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1390860228-21539-6-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 05:03:44PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Use the active_nodes nodemask to make smarter decisions on NUMA migrations.
> 
> In order to maximize performance of workloads that do not fit in one NUMA
> node, we want to satisfy the following criteria:
> 1) keep private memory local to each thread
> 2) avoid excessive NUMA migration of pages
> 3) distribute shared memory across the active nodes, to
>    maximize memory bandwidth available to the workload
> 
> This patch accomplishes that by implementing the following policy for
> NUMA migrations:
> 1) always migrate on a private fault
> 2) never migrate to a node that is not in the set of active nodes
>    for the numa_group
> 3) always migrate from a node outside of the set of active nodes,
>    to a node that is in that set
> 4) within the set of active nodes in the numa_group, only migrate
>    from a node with more NUMA page faults, to a node with fewer
>    NUMA page faults, with a 25% margin to avoid ping-ponging
> 
> This results in most pages of a workload ending up on the actively
> used nodes, with reduced ping-ponging of pages between those nodes.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Chegu Vinod <chegu_vinod@hp.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
