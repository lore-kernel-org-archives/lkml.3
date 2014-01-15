Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaAOCsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:48:55 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:37249 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaAOCsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:48:51 -0500
Date: Tue, 14 Jan 2014 18:48:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org, cl@linux-foundation.org
Subject: Re: [RFC][PATCH 4/9] mm: slabs: reset page at free
In-Reply-To: <20140114180054.20A1B660@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.02.1401141847230.32645@chino.kir.corp.google.com>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180054.20A1B660@viggo.jf.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> diff -puN include/linux/mm.h~slub-reset-page-at-free include/linux/mm.h
> --- a/include/linux/mm.h~slub-reset-page-at-free	2014-01-14 09:57:57.099666808 -0800
> +++ b/include/linux/mm.h	2014-01-14 09:57:57.110667301 -0800
> @@ -2076,5 +2076,16 @@ static inline void set_page_pfmemalloc(s
>  	page->index = pfmemalloc;
>  }
>  
> +/*
> + * Custom allocators (like the slabs) use 'struct page' fields
> + * for all kinds of things.  This resets the page's state so that
> + * the buddy allocator will be happy with it.
> + */
> +static inline void allocator_reset_page(struct page *page)

This is ambiguous as to what "allocator" you're referring to unless we 
look at the comment.  I think it would be better to name it 
slab_reset_page() or something similar.

> +{
> +	page->mapping = NULL;
> +	page_mapcount_reset(page);
> +}
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */
