Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaGVCjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:39:52 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57659 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGVCjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:39:51 -0400
Date: Mon, 21 Jul 2014 19:39:47 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mtd: nand: add ONFI timing mode to nand_timings
 converter
Message-ID: <20140722023947.GZ7537@ld-irv-0074>
References: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
 <1405064982-11456-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405064982-11456-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 09:49:42AM +0200, Boris BREZILLON wrote:
> --- /dev/null
> +++ b/drivers/mtd/nand/nand_timings.c
> @@ -0,0 +1,250 @@
> +/*
> + *  Copyright (C) 2014 Free Electrons
> + *
> + *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/mtd/nand.h>
[...]
> +/**
> + * onfi_async_timing_mode_to_sdr_timings - [NAND Interface] Retrieve NAND
> + * timings according to the given ONFI timing mode
> + * @mode: ONFI timing mode
> + */
> +const struct nand_sdr_timings *onfi_async_timing_mode_to_sdr_timings(int mode)
> +{
> +	if (mode < 0 || mode >= ARRAY_SIZE(onfi_sdr_timings))

Might need <linux/kernel.h> for this.

> +		return ERR_PTR(-EINVAL);

And <linux/err.h> for this.

> +
> +	return &onfi_sdr_timings[mode];
> +}
> +EXPORT_SYMBOL(onfi_async_timing_mode_to_sdr_timings);

<linux/export.h> for this.

I'll squash in the appended diff.

Brian

diff --git a/drivers/mtd/nand/nand_timings.c b/drivers/mtd/nand/nand_timings.c
index f154780cf60f..8b36253420fa 100644
--- a/drivers/mtd/nand/nand_timings.c
+++ b/drivers/mtd/nand/nand_timings.c
@@ -8,6 +8,9 @@
  * published by the Free Software Foundation.
  *
  */
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/export.h>
 #include <linux/mtd/nand.h>
 
 static const struct nand_sdr_timings onfi_sdr_timings[] = {

