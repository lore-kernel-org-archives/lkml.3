Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaGHG02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:26:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20320 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751704AbaGHG01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:26:27 -0400
X-IronPort-AV: E=Sophos;i="5.00,855,1396972800"; 
   d="scan'208";a="32980056"
Message-ID: <53BB8EEF.6050101@cn.fujitsu.com>
Date: Tue, 8 Jul 2014 14:25:51 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
Subject: Re: [PATCH v11 2/7] x86: add pmd_[dirty|mkclean] for THP
References: <1404799424-1120-1-git-send-email-minchan@kernel.org> <1404799424-1120-3-git-send-email-minchan@kernel.org>
In-Reply-To: <1404799424-1120-3-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 02:03 PM, Minchan Kim wrote:
> MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
> overwrite of the contents since MADV_FREE syscall is called for
> THP page.
> 
> This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
> support.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  arch/x86/include/asm/pgtable.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 0ec056012618..329865799653 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -104,6 +104,11 @@ static inline int pmd_young(pmd_t pmd)
>  	return pmd_flags(pmd) & _PAGE_ACCESSED;
>  }
>  
> +static inline int pmd_dirty(pmd_t pmd)
> +{
> +	return pmd_flags(pmd) & _PAGE_DIRTY;
> +}
> +
>  static inline int pte_write(pte_t pte)
>  {
>  	return pte_flags(pte) & _PAGE_RW;
> @@ -267,6 +272,11 @@ static inline pmd_t pmd_mkold(pmd_t pmd)
>  	return pmd_clear_flags(pmd, _PAGE_ACCESSED);
>  }
>  
> +static inline pmd_t pmd_mkclean(pmd_t pmd)
> +{
> +	return pmd_clear_flags(pmd, _PAGE_DIRTY);
> +}
> +
>  static inline pmd_t pmd_wrprotect(pmd_t pmd)
>  {
>  	return pmd_clear_flags(pmd, _PAGE_RW);
> 


-- 
Thanks.
Zhang Yanfei
