Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaIBM3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:29:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbaIBM3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:29:47 -0400
Date: Tue, 2 Sep 2014 08:29:28 -0400
From: Rafael Aquini <aquini@redhat.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH v2 1/6] mm/balloon_compaction: ignore anonymous pages
Message-ID: <20140902122927.GB14419@t510.redhat.com>
References: <20140830163834.29066.98205.stgit@zurg>
 <20140830164109.29066.46373.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140830164109.29066.46373.stgit@zurg>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 08:41:09PM +0400, Konstantin Khlebnikov wrote:
> From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> 
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

