Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaAYF0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 00:26:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44593 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbaAYF0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 00:26:03 -0500
Date: Sat, 25 Jan 2014 02:26:12 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mtd: block2mtd: mutex_init moved
Message-ID: <20140125052611.GA24609@localhost>
References: <20140123205456.10e45ea0baff94cf3f785a21@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123205456.10e45ea0baff94cf3f785a21@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:54:56PM +0100, Fabian Frederick wrote:
> mutex_init declared when mtd structure is available
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/mtd/devices/block2mtd.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
> index f0fd4fc..5b9b145 100644
> --- a/drivers/mtd/devices/block2mtd.c
> +++ b/drivers/mtd/devices/block2mtd.c
> @@ -254,16 +254,15 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
>  		goto devinit_err1;
>  	}
>  
> +	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
> +	if (!name)
> +		goto devinit_err1;
> +
>  	mutex_init(&dev->write_mutex);
>  
>  	/* Setup the MTD structure */
>  	/* make the name contain the block device in */
> -	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
> -	if (!name)
> -		goto devinit_err2;
> -
>  	dev->mtd.name = name;
> -
>  	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
>  	dev->mtd.erasesize = erase_size;
>  	dev->mtd.writesize = 1;
> -- 
> 1.8.1.4

Hm.. this change doesn't seem to make sense. You just moved the name
format to happen before the mutex_init. I wonder if I'm missing something.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
