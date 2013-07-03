Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab3GCS2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:28:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45006 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab3GCS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:28:38 -0400
Date: Wed, 3 Jul 2013 20:27:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/13] sched: Favour moving tasks towards nodes that
 incurred more faults
Message-ID: <20130703182748.GA18898@dyad.programming.kicks-ass.net>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-10-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372861300-9973-10-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 03:21:36PM +0100, Mel Gorman wrote:
>  static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
>  {

> +	if (p->numa_faults[task_faults_idx(dst_nid, 1)] >
> +	    p->numa_faults[task_faults_idx(src_nid, 1)])
> +		return true;

> +}

> +static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
> +{

> +	if (p->numa_faults[src_nid] > p->numa_faults[dst_nid])
>  		return true;

I bet you wanted to use task_faults_idx() there too ;-)


