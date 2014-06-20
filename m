Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbaFTJeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:34:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43697 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964815AbaFTJeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:34:14 -0400
Date: Fri, 20 Jun 2014 10:33:40 +0100
From: Will Deacon <will.deacon@arm.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        David Riley <davidriley@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 1/5] lib/genalloc.c: Add power aligned algorithm
Message-ID: <20140620093340.GL25104@arm.com>
References: <1402969165-7526-1-git-send-email-lauraa@codeaurora.org>
 <1402969165-7526-2-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402969165-7526-2-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laura,

On Tue, Jun 17, 2014 at 02:39:21AM +0100, Laura Abbott wrote:
> One of the more common algorithms used for allocation
> is to align the start address of the allocation to
> the order of size requested. Add this as an algorithm
> option for genalloc.

Good idea, I didn't know this even existed!

> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  include/linux/genalloc.h |  4 ++++
>  lib/genalloc.c           | 21 +++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
> index 1c2fdaa..3cd0934 100644
> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -110,6 +110,10 @@ extern void gen_pool_set_algo(struct gen_pool *pool, genpool_algo_t algo,
>  extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
>  		unsigned long start, unsigned int nr, void *data);
>  
> +extern unsigned long gen_pool_first_fit_order_align(unsigned long *map,
> +		unsigned long size, unsigned long start, unsigned int nr,
> +		void *data);
> +
>  extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
>  		unsigned long start, unsigned int nr, void *data);
>  
> diff --git a/lib/genalloc.c b/lib/genalloc.c
> index bdb9a45..9758529 100644
> --- a/lib/genalloc.c
> +++ b/lib/genalloc.c
> @@ -481,6 +481,27 @@ unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
>  EXPORT_SYMBOL(gen_pool_first_fit);
>  
>  /**
> + * gen_pool_first_fit_order_align - find the first available region
> + * of memory matching the size requirement. The region will be aligned
> + * to the order of the size specified.
> + * @map: The address to base the search on
> + * @size: The bitmap size in bits
> + * @start: The bitnumber to start searching at
> + * @nr: The number of zeroed bits we're looking for
> + * @data: additional data - unused

It doesn't look unused to me.

> + */
> +unsigned long gen_pool_first_fit_order_align(unsigned long *map,
> +		unsigned long size, unsigned long start,
> +		unsigned int nr, void *data)
> +{
> +	unsigned long order = (unsigned long) data;
> +	unsigned long align_mask = (1 << get_order(nr << order)) - 1;

Why isn't the order just order?

Will
