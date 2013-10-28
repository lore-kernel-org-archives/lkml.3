Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab3J1QEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:04:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60950 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3J1QEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:04:11 -0400
Message-ID: <526E8AF9.6070300@codeaurora.org>
Date: Mon, 28 Oct 2013 09:04:09 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: zhang.mingjun@linaro.org, minchan@kernel.org, m.szyprowski@samsung.com,
        akpm@linux-foundation.org, mgorman@suse.de, haojian.zhuang@linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
CC: Mingjun Zhang <troy.zhangmingjun@linaro.org>
Subject: Re: [PATCH] mm: cma: free cma page to buddy instead of being cpu
 hot  page
References: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org>
In-Reply-To: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 4:42 AM, zhang.mingjun@linaro.org wrote:
> From: Mingjun Zhang <troy.zhangmingjun@linaro.org>
>
> free_contig_range frees cma pages one by one and MIGRATE_CMA pages will be
> used as MIGRATE_MOVEABLE pages in the pcp list, it causes unnecessary
> migration action when these pages reused by CMA.
>
> Signed-off-by: Mingjun Zhang <troy.zhangmingjun@linaro.org>
> ---
>   mm/page_alloc.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0ee638f..84b9d84 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1362,7 +1362,8 @@ void free_hot_cold_page(struct page *page, int cold)
>   	 * excessively into the page allocator
>   	 */
>   	if (migratetype >= MIGRATE_PCPTYPES) {
> -		if (unlikely(is_migrate_isolate(migratetype))) {
> +		if (unlikely(is_migrate_isolate(migratetype))
> +			|| is_migrate_cma(migratetype))
>   			free_one_page(zone, page, 0, migratetype);
>   			goto out;
>   		}
>


I submitted something very similar a while ago 
http://marc.info/?l=linaro-mm-sig&m=137645764208287&w=2 . Has the 
opinion on this patch changed?

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
