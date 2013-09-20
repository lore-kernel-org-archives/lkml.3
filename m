Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3ITMhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:37:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3ITMhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:37:18 -0400
Date: Fri, 20 Sep 2013 14:36:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 46/50] sched: numa: Prevent parallel updates to group
 stats during placement
Message-ID: <20130920123656.GS12926@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-47-git-send-email-mgorman@suse.de>
 <20130920095526.GT9326@twins.programming.kicks-ass.net>
 <20130920123151.GX22421@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920123151.GX22421@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 01:31:52PM +0100, Mel Gorman wrote:
>  static inline unsigned long group_weight(struct task_struct *p, int nid)
>  {
> +	if (!p->numa_group || !p->numa_group->total_faults)
>  		return 0;
>  
> +	return 1200 * group_faults(p, nid) / p->numa_group->total_faults;
>  }

Unrelated to this change; I recently thought we might want to change
these weight factors based on if the task was predominantly private or
shared.

For shared we use the bigger weight for group, for private we use the
bigger weight for task.
