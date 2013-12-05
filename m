Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3LENfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:35:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab3LENfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:35:40 -0500
Date: Thu, 5 Dec 2013 13:35:36 +0000
From: Mel Gorman <mgorman@suse.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/15] mm: thp: give transparent hugepage code a separate
 copy_page
Message-ID: <20131205133536.GH11295@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
 <1386060721-3794-4-git-send-email-mgorman@suse.de>
 <20131204165918.GA13191@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131204165918.GA13191@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 10:59:18AM -0600, Alex Thorlton wrote:
> > -void copy_huge_page(struct page *dst, struct page *src)
> > -{
> > -	int i;
> > -	struct hstate *h = page_hstate(src);
> > -
> > -	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
> 
> With CONFIG_HUGETLB_PAGE=n, the kernel fails to build, throwing this
> error:
> 
> mm/migrate.c: In function ???copy_huge_page???:
> mm/migrate.c:473: error: implicit declaration of function ???page_hstate???
> 
> I got it to build by sticking the following into hugetlb.h:
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 4694afc..fd76912 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -403,6 +403,7 @@ struct hstate {};
>  #define hstate_sizelog(s) NULL
>  #define hstate_vma(v) NULL
>  #define hstate_inode(i) NULL
> +#define page_hstate(p) NULL
>  #define huge_page_size(h) PAGE_SIZE
>  #define huge_page_mask(h) PAGE_MASK
>  #define vma_kernel_pagesize(v) PAGE_SIZE
> 
> I figure that the #define I stuck in isn't actually solving the real
> problem, but it got things working again.
> 

It's based on an upstream patch so I'll check if the problem is there as
well and backport accordingly. This patch to unblock yourself is fine
for now.

Thanks.

-- 
Mel Gorman
SUSE Labs
