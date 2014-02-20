Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaBTH3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:29:24 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61018 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaBTH3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:29:23 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: replace obsolete simple_strtol() with kstrtoul()
Date: Thu, 20 Feb 2014 16:29:17 +0900
Message-ID: <1820944.t66uX45pOm@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5791590.Wk0FXrlaj4@daeseok-laptop.cloud.net>
References: <5791590.Wk0FXrlaj4@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@kernel.dk account doesn't exist.

TO+ :
akpm@linux-foundation.org, axboe@kernel.dk

On Thursday, February 20, 2014 03:56:30 PM you wrote:
> From cac24db7480b10b671d05320e0cb97a7bf5d0aea Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Thu, 20 Feb 2014 15:35:14 +0900
> Subject: [PATCH] block: replace obsolete simple_strtol() with kstrtoul()
> 
> - Makes rd_size value as static, because it is only
> referenced in this file.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/block/brd.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index e73b85c..a33d8d3 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -429,12 +429,12 @@ static const struct block_device_operations brd_fops =
> { * And now the modules code and kernel interface.
>   */
>  static int rd_nr;
> -int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> +static unsigned long rd_size = CONFIG_BLK_DEV_RAM_SIZE;
>  static int max_part;
>  static int part_shift;
>  module_param(rd_nr, int, S_IRUGO);
>  MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
> -module_param(rd_size, int, S_IRUGO);
> +module_param(rd_size, ulong, S_IRUGO);
>  MODULE_PARM_DESC(rd_size, "Size of each RAM disk in kbytes.");
>  module_param(max_part, int, S_IRUGO);
>  MODULE_PARM_DESC(max_part, "Maximum number of partitions per RAM disk");
> @@ -446,7 +446,8 @@ MODULE_ALIAS("rd");
>  /* Legacy boot options - nonmodular */
>  static int __init ramdisk_size(char *str)
>  {
> -	rd_size = simple_strtol(str, NULL, 0);
> +	if (kstrtoul(str, 0, &rd_size) < 0)
> +		return 0;
>  	return 1;
>  }
>  __setup("ramdisk_size=", ramdisk_size);
