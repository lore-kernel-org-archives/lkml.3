Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaLJGzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:55:05 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54238 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaLJGzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:55:03 -0500
Date: Wed, 10 Dec 2014 07:54:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dave@sr71.net,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH V3 2/2] x86/mm: use min instead of min_t
Message-ID: <20141210065457.GA20596@gmail.com>
References: <5487AB3F.7050807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5487AB3F.7050807@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xishi Qiu <qiuxishi@huawei.com> wrote:

> The type of "MAX_DMA_PFN" and "xXx_pfn" are both unsigned long now, so use
> min() instead of min_t().
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/x86/kernel/e820.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 49f8864..dd2f07a 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1114,8 +1114,8 @@ void __init memblock_find_dma_reserve(void)
>  	 * at first, and assume boot_mem will not take below MAX_DMA_PFN
>  	 */
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> -		start_pfn = min_t(unsigned long, start_pfn, MAX_DMA_PFN);
> -		end_pfn = min_t(unsigned long, end_pfn, MAX_DMA_PFN);
> +		start_pfn = min(start_pfn, MAX_DMA_PFN);
> +		end_pfn = min(end_pfn, MAX_DMA_PFN);
>  		nr_pages += end_pfn - start_pfn;

Yes, harmonizing the types is a much nicer solution, it allows 
cleanups like this.

Thanks,

	Ingo
