Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaEOSCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:02:25 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:59974 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbaEOSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:02:24 -0400
Message-ID: <53750129.6060902@imgtec.com>
Date: Thu, 15 May 2014 11:02:17 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <linux-arch@vger.kernel.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        "John Crispin" <blogic@openwrt.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        <linux-mips@linux-mips.org>
Subject: Re: [PATCH 16/27] mips: Use common bits from generic tlb.h
References: <1400093999-18703-1-git-send-email-richard@nod.at> <1400093999-18703-17-git-send-email-richard@nod.at>
In-Reply-To: <1400093999-18703-17-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 11:59 AM, Richard Weinberger wrote:
> It is no longer needed to define them on our own.
>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: John Crispin <blogic@openwrt.org>
> Cc: Markos Chandras <markos.chandras@imgtec.com>
> Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: linux-mips@linux-mips.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   arch/mips/include/asm/tlb.h | 7 -------
>   1 file changed, 7 deletions(-)
>
> diff --git a/arch/mips/include/asm/tlb.h b/arch/mips/include/asm/tlb.h
> index 4a23493..5ea43ca 100644
> --- a/arch/mips/include/asm/tlb.h
> +++ b/arch/mips/include/asm/tlb.h
> @@ -10,13 +10,6 @@
>   		if (!tlb->fullmm)				\
>   			flush_cache_range(vma, vma->vm_start, vma->vm_end); \
>   	}  while (0)
> -#define tlb_end_vma(tlb, vma) do { } while (0)
> -#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
> -
> -/*
> - * .. because we flush the whole mm when it fills up.
> - */
> -#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
>   
>   #define UNIQUE_ENTRYHI(idx)						\
>   		((CKSEG0 + ((idx) << (PAGE_SHIFT + 1))) |		\

I would like to know why these functions are eliminated (don't find any 
clue).
Is it just because there will be a generic one or the calls would be 
eliminated?
And if there are generic - can I tune it later?

Explanation of Q:  MIPS R6 architecture has now TLBINV instruction which 
eliminates TLB elements only for specific ASID (read here - "mm_struct") 
and I would like to use it for efficiency in tlb_flush()/flush_tlb_mm.
(Not sure about tlb_end_vma()/ __tlb_remove_tlb_entry() yet)

- Leonid.
