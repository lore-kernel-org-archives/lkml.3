Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaAQHCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:02:17 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48310 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaAQHCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:02:15 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-8b-52d8d5758931
Date: Fri, 17 Jan 2014 16:03:08 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 7/8] zram: drop not used table `count' member
Message-ID: <20140117070308.GJ26602@bbox>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389877936-15543-8-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389877936-15543-8-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:12:15PM +0300, Sergey Senozhatsky wrote:
> struct table `count' member is not used.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

There is no gain with this patch in memory space ponit of view but it
might reveal the lurking bug.

Acked-by: Minchan Kim <minchan@kernel.org>

> ---
>  drivers/block/zram/zram_drv.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 58d4ac5..1d5b1f5 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -64,7 +64,6 @@ enum zram_pageflags {
>  struct table {
>  	unsigned long handle;
>  	u16 size;	/* object size (excluding header) */
> -	u8 count;	/* object ref count (not yet used) */
>  	u8 flags;
>  } __aligned(4);
>  
> -- 
> 1.8.5.3.493.gb139ac2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
