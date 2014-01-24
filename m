Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaAXWKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:10:05 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44246 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674AbaAXWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:10:02 -0500
Date: Fri, 24 Jan 2014 19:10:11 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mtd: block2mtd: char mtd major check
Message-ID: <20140124214836.GA14088@localhost>
References: <20140123204947.fc1c03dc0a1624d3347b3837@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123204947.fc1c03dc0a1624d3347b3837@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:49:47PM +0100, Fabian Frederick wrote:
> Deny use of a char mtd device to map as a block device.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/mtd/devices/block2mtd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
> index d9fd87a..0efee5b 100644
> --- a/drivers/mtd/devices/block2mtd.c
> +++ b/drivers/mtd/devices/block2mtd.c
> @@ -244,7 +244,8 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
>  	}
>  	dev->blkdev = bdev;
>  
> -	if (MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) {
> +	if ((MAJOR(bdev->bd_dev) == MTD_BLOCK_MAJOR) ||
> +	    (MAJOR(bdev->bd_dev) == MTD_CHAR_MAJOR)) {
>  		pr_err("attempting to use an MTD device as a block device\n");
>  		goto devinit_err;
>  	}
> -- 
> 1.8.1.4

Now that the changes are separated on a per-patch basis they're much
much easier to review. Thanks!

Regarding this changes, it seems to me it's not needed. Are you sure
you can attach "block2mtd" to a char MTD device?

That would be odd, given this function calls blkdev_get_by_{path/dev};
which will check the device is of block type in the first place.

What's your motivation for this change?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
