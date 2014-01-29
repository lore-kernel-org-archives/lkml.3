Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaA2KER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:04:17 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59297 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750925AbaA2KEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:04:15 -0500
Date: Wed, 29 Jan 2014 07:04:25 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Fabian Frederick <fabf@skynet.be>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mtd: block2mtd: check device size
Message-ID: <20140129100424.GA15271@localhost>
References: <20140123205331.03314c6f82f24a6bb4b8ef53@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123205331.03314c6f82f24a6bb4b8ef53@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

I saw you sent a v2 for one of the patches on this series,
but maybe this is worth considering too.

On Thu, Jan 23, 2014 at 08:53:31PM +0100, Fabian Frederick wrote:
[..]
> -/* FIXME: ensure that mtd->size % erase_size == 0 */
>  static struct block2mtd_dev *add_device(char *devname, int erase_size)
>  {
>  	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
> @@ -250,6 +249,11 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
>  		goto devinit_err1;
>  	}
>  
> +	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
> +		pr_err("erasesize muse be a divisor of device size\n");
> +		goto devinit_err1;
> +	}
> +

Brian: What do you think?

Fabian: Have you tested this patch? Can you elaborate a bit more about
the effect it would have, compared to the current behavior?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
