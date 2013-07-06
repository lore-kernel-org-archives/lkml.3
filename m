Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3GFKlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 06:41:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40645 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3GFKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 06:41:48 -0400
Date: Sat, 6 Jul 2013 12:41:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/15] sched: Set preferred NUMA node based on number of
 private faults
Message-ID: <20130706104107.GR18898@dyad.programming.kicks-ass.net>
References: <1373065742-9753-1-git-send-email-mgorman@suse.de>
 <1373065742-9753-14-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373065742-9753-14-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:09:00AM +0100, Mel Gorman wrote:
> +++ b/include/linux/mm.h
> @@ -582,11 +582,11 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
>   * sets it, so none of the operations on it need to be atomic.
>   */
>  
> -/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NID] | ... | FLAGS | */
> +/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_NIDPID] | ... | FLAGS | */
>  #define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
>  #define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
>  #define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
> -#define LAST_NID_PGOFF		(ZONES_PGOFF - LAST_NID_WIDTH)
> +#define LAST_NIDPID_PGOFF	(ZONES_PGOFF - LAST_NIDPID_WIDTH)

I saw the same with Ingo's patch doing the similar thing. But why do we fuse
these two into a single field? Would it not make more sense to have them be
separate fields?

Yes I get we update and read them together, and we could still do that with
appropriate helper function, but they are two independent values stored in the
page flags.

Its not something I care too much about, just something that strikes me as weird.
