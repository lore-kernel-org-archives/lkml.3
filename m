Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaEOIXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:23:18 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:53683 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:23:12 -0400
Message-ID: <5374795E.5080305@synopsys.com>
Date: Thu, 15 May 2014 13:52:54 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch
To: Richard Weinberger <richard@nod.at>, <linux-arch@vger.kernel.org>,
        <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/27] arc: Use common bits from generic tlb.h
References: <1400093999-18703-1-git-send-email-richard@nod.at> <1400093999-18703-6-git-send-email-richard@nod.at>
In-Reply-To: <1400093999-18703-6-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thursday 15 May 2014 12:29 AM, Richard Weinberger wrote:
> It is no longer needed to define them on our own.
> 
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thx for the series.

Acked-by: Vineet Gupta <vgupta@synopsys.com>


> ---
>  arch/arc/include/asm/tlb.h | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arc/include/asm/tlb.h b/arch/arc/include/asm/tlb.h
> index a9db5f6..a0fa06d 100644
> --- a/arch/arc/include/asm/tlb.h
> +++ b/arch/arc/include/asm/tlb.h
> @@ -23,9 +23,7 @@ do {						\
>   *
>   * Note, read http://lkml.org/lkml/2004/1/15/6
>   */
> -#ifndef CONFIG_ARC_CACHE_VIPT_ALIASING
> -#define tlb_start_vma(tlb, vma)
> -#else
> +#ifdef CONFIG_ARC_CACHE_VIPT_ALIASING
>  #define tlb_start_vma(tlb, vma)						\
>  do {									\
>  	if (!tlb->fullmm)						\
> @@ -39,8 +37,6 @@ do {									\
>  		flush_tlb_range(vma, vma->vm_start, vma->vm_end);	\
>  } while (0)
>  
> -#define __tlb_remove_tlb_entry(tlb, ptep, address)
> -
>  #include <linux/pagemap.h>
>  #include <asm-generic/tlb.h>
>  
> 

