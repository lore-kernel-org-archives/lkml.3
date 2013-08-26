Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3HZQPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:15:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3HZQPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:15:05 -0400
Date: Mon, 26 Aug 2013 18:14:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm, sched, numa: Create a per-task MPOL_INTERLEAVE policy
Message-ID: <20130826161457.GB10002@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <20130725104633.GQ27075@twins.programming.kicks-ass.net>
 <20130726095528.GB20909@twins.programming.kicks-ass.net>
 <20130826161027.GA10002@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826161027.GA10002@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 06:10:27PM +0200, Peter Zijlstra wrote:
> +	if (pol == new) {
> +		/*
> +		 * XXX 'borrowed' from do_set_mempolicy()

This should probably also say something like:

 /*
  * This is safe without holding mm->mmap_sem for show_numa_map()
  * because this is only used for a NULL->pol transition, not
  * pol1->pol2 transitions.
  */

> +		 */
> +		pol->v.nodes = nodes;
> +		p->mempolicy = pol;
> +		p->flags |= PF_MEMPOLICY;
> +		p->il_next = first_node(nodes);
> +		new = NULL;
> +	} else {
