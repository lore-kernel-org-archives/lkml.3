Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3GAQgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:36:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51662 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3GAQgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:36:24 -0400
Message-ID: <51D1AFFB.4010307@gmail.com>
Date: Tue, 02 Jul 2013 00:36:11 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: penberg@kernel.org, cl@linux-foundation.org, mpm@selenic.com
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH] mm, slab: Drop unnecessary slabp->inuse < cachep->num
 test
References: <51D1AE84.8010404@gmail.com>
In-Reply-To: <51D1AE84.8010404@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for making noise. I've made a mistake and please ignore this patch.

On 07/02/2013 12:29 AM, Zhang Yanfei wrote:
> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> In function cache_alloc_refill, we have used BUG_ON to ensure
> that slabp->inuse is less than cachep->num before the while
> test. And in the while body, we do not change the value of
> slabp->inuse and cachep->num, so it is not necessary to test
> if slabp->inuse < cachep->num test for every loop.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 8ccd296..c2076c2 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3004,7 +3004,7 @@ retry:
>  		 */
>  		BUG_ON(slabp->inuse >= cachep->num);
>  
> -		while (slabp->inuse < cachep->num && batchcount--) {
> +		while (batchcount--) {
>  			STATS_INC_ALLOCED(cachep);
>  			STATS_INC_ACTIVE(cachep);
>  			STATS_SET_HIGH(cachep);


-- 
Thanks.
Zhang Yanfei
