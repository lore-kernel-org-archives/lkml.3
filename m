Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaHTXci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 19:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaHTXch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 19:32:37 -0400
Date: Wed, 20 Aug 2014 20:32:21 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mm/balloon_compaction: ignore anonymous pages
Message-ID: <20140820233221.GB3457@optiplex.redhat.com>
References: <20140820150435.4194.28003.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820150435.4194.28003.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 07:04:35PM +0400, Konstantin Khlebnikov wrote:
> Sasha Levin reported KASAN splash inside isolate_migratepages_range().
> Problem is in function __is_movable_balloon_page() which tests AS_BALLOON_MAP
> in page->mapping->flags. This function has no protection against anonymous
> pages. As result it tried to check address space flags in inside anon-vma.
> 
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Link: http://lkml.kernel.org/p/53E6CEAA.9020105@oracle.com
> Cc: stable <stable@vger.kernel.org> # v3.8
> ---
>  include/linux/balloon_compaction.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index 089743a..53d482e 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -128,7 +128,7 @@ static inline bool page_flags_cleared(struct page *page)
>  static inline bool __is_movable_balloon_page(struct page *page)
>  {
>  	struct address_space *mapping = page->mapping;
> -	return mapping_balloon(mapping);
> +	return !PageAnon(page) && mapping_balloon(mapping);
>  }
>  
>  /*
> 
Acked-by: Rafael Aquini <aquini@redhat.com>
