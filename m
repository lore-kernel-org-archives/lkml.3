Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaAPScg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:32:36 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:57604 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbaAPSce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:32:34 -0500
Date: Thu, 16 Jan 2014 12:32:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 4/9] mm: slabs: reset page at free
In-Reply-To: <20140114180054.20A1B660@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1401161232010.30036@nuc>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180054.20A1B660@viggo.jf.intel.com>
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
> +{
> +	page->mapping = NULL;
> +	page_mapcount_reset(page);
> +}
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */

This belongs into mm/slab.h

Otherwise Acked-by: Christoph Lameter <cl@linux.com>
