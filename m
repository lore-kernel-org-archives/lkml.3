Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaDPS0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:26:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58701 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaDPS0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:26:48 -0400
Date: Wed, 16 Apr 2014 20:26:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org
Subject: Re: [PATCH] kexec: Fix ->unuseable_pages typo
Message-ID: <20140416182645.GA5588@pd.tnic>
References: <1392819695-24116-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1392819695-24116-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,

can you pls pick this one up - it seems it fell through the cracks.

Thanks.

On Wed, Feb 19, 2014 at 03:21:35PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Let's use the more common "unusable".
> 
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: kexec@lists.infradead.org
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  include/linux/kexec.h | 2 +-
>  kernel/kexec.c        | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 6d4066cdb5b5..969237e338d1 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -100,7 +100,7 @@ struct kimage {
>  
>  	struct list_head control_pages;
>  	struct list_head dest_pages;
> -	struct list_head unuseable_pages;
> +	struct list_head unusable_pages;
>  
>  	/* Address of next control page to allocate for crash kernels. */
>  	unsigned long control_page;
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 60bafbed06ab..a2d0c5f80bf2 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -152,7 +152,7 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
>  	INIT_LIST_HEAD(&image->dest_pages);
>  
>  	/* Initialize the list of unusable pages */
> -	INIT_LIST_HEAD(&image->unuseable_pages);
> +	INIT_LIST_HEAD(&image->unusable_pages);
>  
>  	/* Read in the segments */
>  	image->nr_segments = nr_segments;
> @@ -607,7 +607,7 @@ static void kimage_free_extra_pages(struct kimage *image)
>  	kimage_free_page_list(&image->dest_pages);
>  
>  	/* Walk through and free any unusable pages I have cached */
> -	kimage_free_page_list(&image->unuseable_pages);
> +	kimage_free_page_list(&image->unusable_pages);
>  
>  }
>  static void kimage_terminate(struct kimage *image)
> @@ -731,7 +731,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
>  		/* If the page cannot be used file it away */
>  		if (page_to_pfn(page) >
>  				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
> -			list_add(&page->lru, &image->unuseable_pages);
> +			list_add(&page->lru, &image->unusable_pages);
>  			continue;
>  		}
>  		addr = page_to_pfn(page) << PAGE_SHIFT;
> -- 
> 1.8.5.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
