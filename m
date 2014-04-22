Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaDVJGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:06:30 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47413 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaDVJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:06:25 -0400
Date: Tue, 22 Apr 2014 12:06:17 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>, iamjoonsoo.kim@lge.com,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: correct offset usage in zram_bio_discard
Message-ID: <20140422090617.GA937@swordfish.minsk.epam.com>
References: <000001cf5dd8$ecf1c360$c6d54a20$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cf5dd8$ecf1c360$c6d54a20$%yang@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (04/22/14 11:14), Weijie Yang wrote:
> 
> we want to skip the logical block which is partially covered by
> the discard bio, so check the remaining size and subtract it if
> there is a need to goto the next logical block.
> 

looks sane.

	-ss

> This patch corrects the offset usage in zram_bio_discard.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> ---
>  drivers/block/zram/zram_drv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 9849b52..48eccb3 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -572,10 +572,10 @@ static void zram_bio_discard(struct zram *zram, u32 index,
>  	 * skipping this logical block is appropriate here.
>  	 */
>  	if (offset) {
> -		if (n < offset)
> +		if (n <= (PAGE_SIZE - offset))
>  			return;
>  
> -		n -= offset;
> +		n -= (PAGE_SIZE - offset);
>  		index++;
>  	}
>  
> -- 
> 1.7.10.4
> 
> 
