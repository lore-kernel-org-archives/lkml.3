Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaJLOht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:37:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJLOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:37:48 -0400
Date: Sun, 12 Oct 2014 16:37:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 3/5] sched,numa: preparations for complex topology
 placement
Message-ID: <20141012143735.GG3015@worktop>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
 <1412797050-8903-4-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412797050-8903-4-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:37:28PM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Preparatory patch for adding NUMA placement on systems with
> complex NUMA topology. Also fix a potential divide by zero
> in group_weight()
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  include/linux/topology.h |  1 +
>  kernel/sched/core.c      |  2 +-
>  kernel/sched/fair.c      | 57 +++++++++++++++++++++++++++++++-----------------
>  3 files changed, 39 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index bf40d46..f8dfad9 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -47,6 +47,7 @@
>  		if (nr_cpus_node(node))
>  
>  int arch_update_cpu_topology(void);
> +extern int sched_domains_numa_levels;
>  extern int node_hops(int i, int j);
>  

I'm not sure we want to share this globally, please consider using
kernel/sched/sched.h
