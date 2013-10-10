Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3JJTP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:15:29 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:57602 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab3JJTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:15:24 -0400
Date: Thu, 10 Oct 2013 21:14:58 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 13/34] avr32: handle pgtable_page_ctor() fail
Message-ID: <20131010191458.GA10670@samfundet.no>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1381428359-14843-14-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381428359-14843-14-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 10 Oct 2013 21:05:38 +0300 or thereabout, Kirill A. Shutemov wrote:
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

Given [1].

> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> ---
>  arch/avr32/include/asm/pgalloc.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/avr32/include/asm/pgalloc.h b/arch/avr32/include/asm/pgalloc.h
> index bc7e8ae479..1aba19d68c 100644
> --- a/arch/avr32/include/asm/pgalloc.h
> +++ b/arch/avr32/include/asm/pgalloc.h
> @@ -68,7 +68,10 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
>  		return NULL;
>  
>  	page = virt_to_page(pg);
> -	pgtable_page_ctor(page);
> +	if (!pgtable_page_ctor(page)) {
> +		quicklist_free(QUICK_PT, NULL, pg);
> +		return NULL;
> +	}
>  
>  	return page;
>  }

1: I'm assuming that pgtable_page_ctor() now returns success/error, but there
is a patch series that I have not seen.

-- 
mvh
Hans-Christian Egtvedt
