Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaHDLlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:41:06 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49497 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaHDLlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:41:04 -0400
Date: Mon, 4 Aug 2014 20:39:54 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Sami Kerola <kerolasa@iki.fi>
Cc: linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] zram: return EBUSY when max_comp_streams change fails
 for device in use
Message-ID: <20140804113954.GA957@swordfish>
References: <1407106129-30705-1-git-send-email-kerolasa@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407106129-30705-1-git-send-email-kerolasa@iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/03/14 23:48), Sami Kerola wrote:
> Both disksize and comp_algorithm return EBUSY when a change is attempted
> to a device in use, and so should max_comp_streams.
> 
> Signed-off-by: Sami Kerola <kerolasa@iki.fi>
> ---
>  drivers/block/zram/zram_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 36e54be..0211734 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -139,7 +139,7 @@ static ssize_t max_comp_streams_store(struct device *dev,
>  	if (init_done(zram)) {
>  		if (!zcomp_set_max_streams(zram->comp, num)) {
>  			pr_info("Cannot change max compression streams\n");
> -			ret = -EINVAL;
> +			ret = -EBUSY;
>  			goto out;
>  		}
>  	}


NACK.

failed zcomp_set_max_streams() has nothing to do with device being busy.

	-ss
