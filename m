Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaFJWyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:54:45 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37405 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaFJWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:54:44 -0400
Date: Tue, 10 Jun 2014 15:54:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] MM/PAGE_ALLOC add __meminit to
 alloc_pages_exact_nid
In-Reply-To: <1402421774-4044-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1406101554000.32203@chino.kir.corp.google.com>
References: <1402421774-4044-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Fabian Frederick wrote:

> alloc_pages_exact_nid is only called by
> __meminit alloc_page_cgroup
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  include/linux/gfp.h | 2 +-
>  mm/page_alloc.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 6eb1fb3..5e7219d 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -360,7 +360,7 @@ extern unsigned long get_zeroed_page(gfp_t gfp_mask);
>  void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
>  void free_pages_exact(void *virt, size_t size);
>  /* This is different from alloc_pages_exact_node !!! */
> -void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
> +void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
>  
>  #define __get_free_page(gfp_mask) \
>  		__get_free_pages((gfp_mask), 0)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4f59fa2..530837e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2949,7 +2949,7 @@ EXPORT_SYMBOL(alloc_pages_exact);
>   * Note this is not alloc_pages_exact_node() which allocates on a specific node,
>   * but is not exact.
>   */
> -void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
> +void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask)
>  {
>  	unsigned order = get_order(size);
>  	struct page *p = alloc_pages_node(nid, gfp_mask, order);

Memcg cannot be compiled as a module, so why are we using EXPORT_SYMBOL()?
