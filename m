Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3EQA42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 20:56:28 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:30306 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225Ab3EQA41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 20:56:27 -0400
From: "Peng, Tao" <tao.peng@emc.com>
To: Cyril Roelandt <tipecaml@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "andreas.dilger@intel.com" <andreas.dilger@intel.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: lustre: fix return type of lo_release.
Thread-Topic: [PATCH] staging: lustre: fix return type of lo_release.
Thread-Index: AQHOUlHYocvJB+cfUkGriSdAkRTs9JkIjAgg
Date: Fri, 17 May 2013 00:56:01 +0000
Message-ID: <1882637210201641A747464075FFC64904175907@MX101CL02.corp.emc.com>
References: <1368720380-20974-1-git-send-email-tipecaml@gmail.com>
In-Reply-To: <1368720380-20974-1-git-send-email-tipecaml@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.218.60]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4H0uuFM026077



> -----Original Message-----
> From: Cyril Roelandt [mailto:tipecaml@gmail.com]
> Sent: Friday, May 17, 2013 12:06 AM
> To: kernel-janitors@vger.kernel.org; gregkh@linuxfoundation.org; andreas.dilger@intel.com; Peng, Tao;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Cc: Cyril Roelandt
> Subject: [PATCH] staging: lustre: fix return type of lo_release.
> 
> The return type of block_device_operations.release() changed to void in commit
> db2a144b.
> 
> Found with the following Coccinelle patch:
> <smpl>
> @has_release_func@
> identifier i;
> identifier release_func;
> @@
> struct block_device_operations i = {
>  .release = release_func
> };
> 
> @depends on has_release_func@
> identifier has_release_func.release_func;
> @@
> - int
> + void
> release_func(...) {
> ...
> - return ...;
> }
> </smpl>
> 
Yeah, thanks for the patch. I have one same patch but am still working on procfs change so didn't send it out. I'd be glad to take yours instead.

Greg, will you take it directly or do you want Andreas and me to queue it first? The patch is absolutely right btw.

Thanks,
Tao

> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> ---
>  drivers/staging/lustre/lustre/llite/lloop.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
> index b72f257..9d4c17e 100644
> --- a/drivers/staging/lustre/lustre/llite/lloop.c
> +++ b/drivers/staging/lustre/lustre/llite/lloop.c
> @@ -596,15 +596,13 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
>  	return 0;
>  }
> 
> -static int lo_release(struct gendisk *disk, fmode_t mode)
> +static void lo_release(struct gendisk *disk, fmode_t mode)
>  {
>  	struct lloop_device *lo = disk->private_data;
> 
>  	mutex_lock(&lo->lo_ctl_mutex);
>  	--lo->lo_refcnt;
>  	mutex_unlock(&lo->lo_ctl_mutex);
> -
> -	return 0;
>  }
> 
>  /* lloop device node's ioctl function. */
> --
> 1.7.10.4
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
