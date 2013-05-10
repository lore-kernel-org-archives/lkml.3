Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3EJISi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:18:38 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:54605 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3EJISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:18:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 3.9-stable] drbd: fix memory leak
Date: Fri, 10 May 2013 10:18:26 +0200
Message-ID: <5002451.SWhbVAhVg4@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-40-lowlatency; KDE/4.8.5; x86_64; ; )
In-Reply-To: <003301ce4c3e$207b06e0$617114a0$%choi@samsung.com>
References: <003301ce4c3e$207b06e0$617114a0$%choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please.

> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?
> 
> ------------------
> 
> From: "Lars Ellenberg <lars.ellenberg@linbit.com>"
> 
> commit 94ad0a101415978be04945b2787be1e8e8a874db upstream
> 
> We forgot to free the disk_conf,
> so for each attach/detach cycle we leaked 336 bytes.
> 
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/block/drbd/drbd_main.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> index e98da67..54d03d4 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -2795,6 +2795,7 @@ void drbd_free_bc(struct drbd_backing_dev *ldev)
>  	blkdev_put(ldev->backing_bdev, FMODE_READ | FMODE_WRITE |
> FMODE_EXCL);
>  	blkdev_put(ldev->md_bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
> 
> +	kfree(ldev->disk_conf);
>  	kfree(ldev);
>  }
