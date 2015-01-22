Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbbAVTy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:54:29 -0500
Received: from g2t2354.austin.hp.com ([15.217.128.53]:48987 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbAVTy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:54:27 -0500
Message-ID: <1421955490.2493.9.camel@misato.fc.hp.com>
Subject: Re: [PATCH] x86: change cachemode symbols to non-gpl to avoid
 breaking out-of-tree modules
From: Toshi Kani <toshi.kani@hp.com>
To: Juergen Gross <jgross@suse.com>
Cc: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org, steven@uplinklabs.net
Date: Thu, 22 Jan 2015 12:38:10 -0700
In-Reply-To: <1421926997-28615-1-git-send-email-jgross@suse.com>
References: <1421926997-28615-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 12:43 +0100, Juergen Gross wrote:
> Commit 281d4078bec366d60990add9d91a952953bd0d72 ("x86: Make page
> cache mode a real type") introduced the symbols __cachemode2pte_tbl
> and __pte2cachemode_tbl and exported them via EXPORT_SYMBOL_GPL.
> This will break building out-of-tree non-gpl modules which need to
> set caching mode in ptes.
> 
> Change EXPORT_SYMBOL_GPL to EXPORT-SYMBOL for these two symbols.
> 
> Reported-by: Stevan Noonan <steven@uplinklabs.net>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

-Toshi

> ---
>  arch/x86/mm/init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 08a7d31..079c3b6 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -43,7 +43,7 @@ uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
>  	[_PAGE_CACHE_MODE_WT]		= _PAGE_PCD,
>  	[_PAGE_CACHE_MODE_WP]		= _PAGE_PCD,
>  };
> -EXPORT_SYMBOL_GPL(__cachemode2pte_tbl);
> +EXPORT_SYMBOL(__cachemode2pte_tbl);
>  uint8_t __pte2cachemode_tbl[8] = {
>  	[__pte2cm_idx(0)] = _PAGE_CACHE_MODE_WB,
>  	[__pte2cm_idx(_PAGE_PWT)] = _PAGE_CACHE_MODE_WC,
> @@ -54,7 +54,7 @@ uint8_t __pte2cachemode_tbl[8] = {
>  	[__pte2cm_idx(_PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC_MINUS,
>  	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
>  };
> -EXPORT_SYMBOL_GPL(__pte2cachemode_tbl);
> +EXPORT_SYMBOL(__pte2cachemode_tbl);
>  
>  static unsigned long __initdata pgt_buf_start;
>  static unsigned long __initdata pgt_buf_end;


