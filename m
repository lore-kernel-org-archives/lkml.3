Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbbAVNti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:49:38 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:38748 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbAVNtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:49:36 -0500
MIME-Version: 1.0
In-Reply-To: <1421926997-28615-1-git-send-email-jgross@suse.com>
References: <1421926997-28615-1-git-send-email-jgross@suse.com>
Date: Thu, 22 Jan 2015 05:49:34 -0800
Message-ID: <CAKbGBLgEwdnYmXt1-YM8FDmvVtgjQ=LdsMT_Xkc8HGRM4UwwJg@mail.gmail.com>
Subject: Re: [PATCH] x86: change cachemode symbols to non-gpl to avoid
 breaking out-of-tree modules
From: Steven Noonan <steven@uplinklabs.net>
To: Juergen Gross <jgross@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        toshi.kani@hp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 3:43 AM, Juergen Gross <jgross@suse.com> wrote:
> Commit 281d4078bec366d60990add9d91a952953bd0d72 ("x86: Make page
> cache mode a real type") introduced the symbols __cachemode2pte_tbl
> and __pte2cachemode_tbl and exported them via EXPORT_SYMBOL_GPL.
> This will break building out-of-tree non-gpl modules which need to
> set caching mode in ptes.
>
> Change EXPORT_SYMBOL_GPL to EXPORT-SYMBOL for these two symbols.
>
> Reported-by: Stevan Noonan <steven@uplinklabs.net>

Steven, not "Stevan". :)

Otherwise, patch looks good. Already tested an identical change
locally and it unbroke the out-of-tree module builds.

> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/mm/init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 08a7d31..079c3b6 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -43,7 +43,7 @@ uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
>         [_PAGE_CACHE_MODE_WT]           = _PAGE_PCD,
>         [_PAGE_CACHE_MODE_WP]           = _PAGE_PCD,
>  };
> -EXPORT_SYMBOL_GPL(__cachemode2pte_tbl);
> +EXPORT_SYMBOL(__cachemode2pte_tbl);
>  uint8_t __pte2cachemode_tbl[8] = {
>         [__pte2cm_idx(0)] = _PAGE_CACHE_MODE_WB,
>         [__pte2cm_idx(_PAGE_PWT)] = _PAGE_CACHE_MODE_WC,
> @@ -54,7 +54,7 @@ uint8_t __pte2cachemode_tbl[8] = {
>         [__pte2cm_idx(_PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC_MINUS,
>         [__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
>  };
> -EXPORT_SYMBOL_GPL(__pte2cachemode_tbl);
> +EXPORT_SYMBOL(__pte2cachemode_tbl);
>
>  static unsigned long __initdata pgt_buf_start;
>  static unsigned long __initdata pgt_buf_end;
> --
> 2.1.2
>
