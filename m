Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaKEQEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:04:21 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65170 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaKEQET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:04:19 -0500
Date: Wed, 5 Nov 2014 08:04:09 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Davidlohr Bueso <dave@stgolabs.net>
cc: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
        mgorman@suse.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/10] mm/hugetlb: share the i_mmap_rwsem
In-Reply-To: <1415149183.6673.12.camel@linux-t7sj.site>
Message-ID: <alpine.LSU.2.11.1411050757170.4224@eggly.anvils>
References: <1414697657-1678-1-git-send-email-dave@stgolabs.net> <1414697657-1678-11-git-send-email-dave@stgolabs.net> <alpine.LSU.2.11.1411032208390.15596@eggly.anvils> <1415149183.6673.12.camel@linux-t7sj.site>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Davidlohr Bueso wrote:
> 8<------------------------------------------------
> From: Davidlohr Bueso <dave@stgolabs.net>
> Subject: [PATCH 11/10] mm/memory.c: share the i_mmap_rwsem
> 
> The unmap_mapping_range family of functions do the unmapping
> of user pages (ultimately via zap_page_range_single) without
> touching the actual interval tree, thus share the lock.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Acked-by: Hugh Dickins <hughd@google.com>

Yes, thanks, let's get this 11/10 into mmotm along with the rest,
but put the hugetlb 10/10 on the shelf for now, until we've had
time to contemplate it more deeply.

> ---
>  mm/memory.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2ca3105..06f2458 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2396,12 +2396,12 @@ void unmap_mapping_range(struct address_space *mapping,
>  		details.last_index = ULONG_MAX;
>  
>  
> -	i_mmap_lock_write(mapping);
> +	i_mmap_lock_read(mapping);
>  	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
>  		unmap_mapping_range_tree(&mapping->i_mmap, &details);
>  	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
>  		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
> -	i_mmap_unlock_write(mapping);
> +	i_mmap_unlock_read(mapping);
>  }
>  EXPORT_SYMBOL(unmap_mapping_range);
>  
> -- 
> 1.8.4.5
