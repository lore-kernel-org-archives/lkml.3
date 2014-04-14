Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbaDNWA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:00:59 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60768 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaDNWA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:00:57 -0400
MIME-Version: 1.0
In-Reply-To: <1397287343-10059-1-git-send-email-nasa4836@gmail.com>
References: <1397287343-10059-1-git-send-email-nasa4836@gmail.com>
Date: Mon, 14 Apr 2014 15:00:56 -0700
Message-ID: <CAFR8ueeGpR=+7RmDHLANUhkdxYiZjrkNODbLeizkSJBCwohMdw@mail.gmail.com>
Subject: Re: [PATCH] block/blk-core.c: print readable string instead of values.
From: Muthukumar R <muthu.lkml@gmail.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, bi_rw tracks more than WRITE or READ...

On Sat, Apr 12, 2014 at 12:22 AM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> Print the r/w direction string instead of internal values.
>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  block/blk-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a0e3096..0a3bde3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1625,9 +1625,9 @@ static void handle_bad_sector(struct bio *bio)
>         char b[BDEVNAME_SIZE];
>
>         printk(KERN_INFO "attempt to access beyond end of device\n");
> -       printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
> +       printk(KERN_INFO "%s: rw=%s, want=%Lu, limit=%Lu\n",
>                         bdevname(bio->bi_bdev, b),
> -                       bio->bi_rw,
> +                       (bio->bi_rw & WRITE) ? "WRITE" : "READ",
>                         (unsigned long long)bio_end_sector(bio),
>                         (long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
>
> --
> 1.9.0.GIT
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
