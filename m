Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab3J3CgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:36:23 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62026 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J3CgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:36:22 -0400
X-AuditID: 9c93016f-b7cb6ae000000e4c-84-527070a43fc2
Date: Wed, 30 Oct 2013 11:36:27 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: opw-kernel@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Staging: zram: Fix access of NULL pointer
Message-ID: <20131030023627.GD17013@bbox>
References: <20131019110539.GA25167@gmail.com>
 <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc16130b4e23207971139eff313a4ec71f51c187.1383087326.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:40:54AM +0530, Rashika Kheria wrote:
> This patch fixes the bug in reset_store caused by accessing NULL pointer.
> 
> The bdev gets its value from bdget_disk() which could fail when memory
> pressure is severe and hence can return NULL because allocation of
> inode in bdget could fail.
> 
> Hence, this patch introduces a check for bdev to prevent reference to a
> NULL pointer in the later part of the code. It also removes unnecessary
> check of bdev for fsync_bdev().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
> 
> This patch fixes the following issues of the previous revision-
> Better Description
> 
>  drivers/staging/zram/zram_drv.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 2c4ed52..d640a8f 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -648,6 +648,9 @@ static ssize_t reset_store(struct device *dev,
>  	zram = dev_to_zram(dev);
>  	bdev = bdget_disk(zram->disk, 0);
>  
> +	if (!bdev)
> +		return -EBUSY;
> +

Oops, Sorry.
I don't think EBUSY is right. How about ENOMEM?

-- 
Kind regards,
Minchan Kim
