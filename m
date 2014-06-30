Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaF3JrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:47:12 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57912 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaF3JrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:47:11 -0400
Date: Mon, 30 Jun 2014 18:46:37 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/2] zram: use size_t instead of u16
Message-ID: <20140630094637.GA1055@swordfish>
References: <1404096879-24529-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404096879-24529-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/30/14 11:54), Minchan Kim wrote:
> Date: Mon, 30 Jun 2014 11:54:38 +0900
> From: Minchan Kim <minchan@kernel.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org, Sergey Senozhatsky
>  <sergey.senozhatsky@gmail.com>, Weijie Yang <weijie.yang@samsung.com>,
>  Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
>  Minchan Kim <minchan@kernel.org>
> Subject: [PATCH 1/2] zram: use size_t instead of u16
> X-Mailer: git-send-email 2.0.0
> 
> Some of arch(ex, hexagon and PowerPC) could use PAGE_SHIFT
> as 16 above. In the case, u16 is is lack of representing
> compressed page's size so use size_t.
> 
> Reported-by: Weijie Yang <weijie.yang@samsung.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> ---
>  drivers/block/zram/zram_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 089e72cd37be..3233bccd6361 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -337,7 +337,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  	unsigned char *cmem;
>  	struct zram_meta *meta = zram->meta;
>  	unsigned long handle;
> -	u16 size;
> +	size_t size;
>  
>  	read_lock(&meta->tb_lock);
>  	handle = meta->table[index].handle;
> -- 
> 2.0.0
> 
