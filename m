Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3JKJ6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:58:01 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:36868 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3JKJ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:57:59 -0400
Date: Fri, 11 Oct 2013 11:57:52 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>
Subject: Re: [PATCH 14/34] cris: handle pgtable_page_ctor() fail
Message-ID: <20131011095752.GG11028@axis.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1381428359-14843-15-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381428359-14843-15-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:05:39PM +0200, Kirill A. Shutemov wrote:
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Mikael Starvik <starvik@axis.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> ---
>  arch/cris/include/asm/pgalloc.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/cris/include/asm/pgalloc.h b/arch/cris/include/asm/pgalloc.h
> index d9504d38c2..235ece437d 100644
> --- a/arch/cris/include/asm/pgalloc.h
> +++ b/arch/cris/include/asm/pgalloc.h
> @@ -34,7 +34,10 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long addres
>  	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
>  	if (!pte)
>  		return NULL;
> -	pgtable_page_ctor(pte);
> +	if (!pgtable_page_ctor(pte)) {
> +		__free_page(pte);
> +		return NULL;
> +	}
>  	return pte;
>  }
>  
> -- 
> 1.8.4.rc3

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
