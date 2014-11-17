Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaKQV3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:29:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaKQV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:29:01 -0500
Date: Mon, 17 Nov 2014 13:29:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move swp_entry_t definition to
 include/linux/mm_types.h
Message-Id: <20141117132900.da426ddb56a3eeb01a484b38@linux-foundation.org>
In-Reply-To: <20141117211723.GH23126@htj.dyndns.org>
References: <20141117211723.GH23126@htj.dyndns.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 16:17:23 -0500 Tejun Heo <tj@kernel.org> wrote:

> swp_entry_t being defined in include/linux/swap.h instead of
> include/linux/mm_types.h causes cyclic include dependency later when
> include/linux/page_cgroup.h is included from writeback path.  Move the
> definition to include/linux/mm_types.h.
> 
> While at it, reformat the comment above it.
>
> ...
>
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -525,4 +525,12 @@ enum tlb_flush_reason {
>  	NR_TLB_FLUSH_REASONS,
>  };
>  
> + /*
> +  * A swap entry has to fit into a "unsigned long", as the entry is hidden
> +  * in the "index" field of the swapper address space.
> +  */
> +typedef struct {
> +	unsigned long val;
> +} swp_entry_t;
> +
>  #endif /* _LINUX_MM_TYPES_H */
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -102,14 +102,6 @@ union swap_header {
>  	} info;
>  };
>  
> - /* A swap entry has to fit into a "unsigned long", as
> -  * the entry is hidden in the "index" field of the
> -  * swapper address space.
> -  */
> -typedef struct {
> -	unsigned long val;
> -} swp_entry_t;
> -
>  /*
>   * current->reclaim_state points to one of these when a task is running
>   * memory reclaim

Looks OK to me.  Do you have some patch which depends on this?  If
so, please merge this via whatever tree carries that patch?

