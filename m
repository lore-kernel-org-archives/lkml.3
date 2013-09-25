Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3IYP4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3IYP4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:56:16 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] block: Set inode of block_device size to zero when delete gendisk.
References: <201309171121587796647@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 25 Sep 2013 11:56:12 -0400
In-Reply-To: <201309171121587796647@gmail.com> (majianpeng@gmail.com's message
	of "Tue, 17 Sep 2013 11:22:01 +0800")
Message-ID: <x49ob7gevz7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

majianpeng <majianpeng@gmail.com> writes:

> When remove gendisk, set the size of inode of block_device to zero.
> This is mainly let the vfs know disk removed.
>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

> ---
>  block/genhd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index dadf42b..9a4c245 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1369,6 +1369,12 @@ int invalidate_partition(struct gendisk *disk, int partno)
>  	if (bdev) {
>  		fsync_bdev(bdev);
>  		res = __invalidate_device(bdev, true);
> +		/*
> +		 * When used buffer-mode on raw blockdevice,the disk removed.
> +		 * But the vfs don't know.So tell the vfs size of disk
> +		 * became zero, the buffer write can return
> +		 */
> +		i_size_write(bdev->bd_inode, 0);
>  		bdput(bdev);
>  	}
>  	return res;
