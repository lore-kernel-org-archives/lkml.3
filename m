Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaKMOzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:55:17 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40668 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaKMOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:55:13 -0500
Date: Thu, 13 Nov 2014 23:55:33 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: ngupta@vflare.org, minchan@kernel.org, weijie.yang@samsung.com,
        sergey.senozhatsky@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zram: correct ZRAM_ZERO flag bit position
Message-ID: <20141113145533.GA1408@swordfish>
References: <1415803038-7913-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415803038-7913-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/12/14 22:37), Mahendran Ganesh wrote:
> In struct zram_table_entry, the element *value* contains obj size and
> obj zram flags. Bit 0 to bit (ZRAM_FLAG_SHIFT - 1) represent obj size,
> and bit ZRAM_FLAG_SHIFT to the highest bit of unsigned long represent obj
> zram_flags. So the first zram flag(ZRAM_ZERO) should be from ZRAM_FLAG_SHIFT
> instead of (ZRAM_FLAG_SHIFT + 1).
> 
> This patch fixes this issue.

well, I wouldn't say this is an issue; but still.

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> Also this patch fixes a typo, "page in now accessed" -> "page is now accessed"
> 
> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
> ---
>  drivers/block/zram/zram_drv.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index c6ee271..b05a816 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -66,8 +66,8 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
>  /* Flags for zram pages (table[page_no].value) */
>  enum zram_pageflags {
>  	/* Page consists entirely of zeros */
> -	ZRAM_ZERO = ZRAM_FLAG_SHIFT + 1,
> -	ZRAM_ACCESS,	/* page in now accessed */
> +	ZRAM_ZERO = ZRAM_FLAG_SHIFT,
> +	ZRAM_ACCESS,	/* page is now accessed */
>  
>  	__NR_ZRAM_PAGEFLAGS,
>  };
> -- 
> 1.7.9.5
> 
