Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaGMKcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:32:25 -0400
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:44671
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbaGMKcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:32:16 -0400
X-Greylist: delayed 1830 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jul 2014 06:32:16 EDT
Message-ID: <53C258F5.7070305@panasas.com>
Date: Sun, 13 Jul 2014 13:01:25 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: <osd-dev@open-osd.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/exofs/ore_raid.c: replace count*size kzalloc by
 kcalloc
References: <1403720063-19061-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1403720063-19061-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 09:14 PM, Fabian Frederick wrote:
> kcalloc manages count*sizeof overflow.
> 
> Cc: Boaz Harrosh <bharrosh@panasas.com>
ACK-by: Boaz Harrosh <bharrosh@panasas.com>

Do you need that I submit this through my tree?

Thanks
Boaz
> Cc: osd-dev@open-osd.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/exofs/ore_raid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/exofs/ore_raid.c b/fs/exofs/ore_raid.c
> index 7f20f25..84529b8 100644
> --- a/fs/exofs/ore_raid.c
> +++ b/fs/exofs/ore_raid.c
> @@ -116,7 +116,7 @@ static int _sp2d_alloc(unsigned pages_in_unit, unsigned group_width,
>  			num_a1pa = min_t(unsigned, PAGE_SIZE / sizeof__a1pa,
>  							pages_in_unit - i);
>  
> -			__a1pa = kzalloc(num_a1pa * sizeof__a1pa, GFP_KERNEL);
> +			__a1pa = kcalloc(num_a1pa, sizeof__a1pa, GFP_KERNEL);
>  			if (unlikely(!__a1pa)) {
>  				ORE_DBGMSG("!! Failed to _alloc_1p_arrays=%d\n",
>  					   num_a1pa);
> 

