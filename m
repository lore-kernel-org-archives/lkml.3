Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966228AbaFRKkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:40:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48262 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965568AbaFRKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:40:04 -0400
Date: Wed, 18 Jun 2014 11:39:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: export __cpu_{clear,copy}_user_page functions
Message-ID: <20140618103954.GC14680@arm.com>
References: <1403025266-2326-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403025266-2326-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 06:14:26PM +0100, Mark Salter wrote:
> The __cpu_clear_user_page() and __cpu_copy_user_page() functions
> are not currently exported. This prevents modules from using
> clear_user_page() and opy_user_page().
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  arch/arm64/mm/copypage.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index 9aecbac..13bbc3be 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -27,8 +27,10 @@ void __cpu_copy_user_page(void *kto, const void *kfrom, unsigned long vaddr)
>  	copy_page(kto, kfrom);
>  	__flush_dcache_area(kto, PAGE_SIZE);
>  }
> +EXPORT_SYMBOL_GPL(__cpu_copy_user_page);
>  
>  void __cpu_clear_user_page(void *kaddr, unsigned long vaddr)
>  {
>  	clear_page(kaddr);
>  }
> +EXPORT_SYMBOL_GPL(__cpu_clear_user_page);

I wonder why we still have these functions. I don't think we need any
D-cache flushing for copy_user_page(), so we could simply remove this
code and define copy_user_page() as copy_page() (similarly for
clear_user_page). I'll post a patch separately removing the copy_page,
copy_user_page etc. functions (now that we also have optimised memcpy
and memset).

-- 
Catalin
