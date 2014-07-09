Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaGIR0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:26:03 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61403 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaGIR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:26:00 -0400
Date: Wed, 9 Jul 2014 10:25:55 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 2/9] mtd: nand: add ONFI timing mode to nand_timings
 converter
Message-ID: <20140709172555.GI7537@ld-irv-0074>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-3-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394647664-8258-3-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Since I think you were planning on revisiting this soon, I have one more
comment:

On Wed, Mar 12, 2014 at 07:07:37PM +0100, Boris BREZILLON wrote:
> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
> index c970ce7..0b8a822 100644
> --- a/drivers/mtd/nand/Makefile
> +++ b/drivers/mtd/nand/Makefile
> @@ -2,7 +2,7 @@
>  # linux/drivers/nand/Makefile
>  #
>  
> -obj-$(CONFIG_MTD_NAND)			+= nand.o
> +obj-$(CONFIG_MTD_NAND)			+= nand.o nand_timings.o

This is not the right place, as it will generate a new module
'nand_timings' (nand_timings.ko, if CONFIG_MTD_NAND=m). You probably
want to just add nand_timings.o to the 'nand-objs' list at the bottom of
the Makefile, like this:

	nand-objs := nand_base.o nand_bbt.o nand_timings.o

>  obj-$(CONFIG_MTD_NAND_ECC)		+= nand_ecc.o
>  obj-$(CONFIG_MTD_NAND_BCH)		+= nand_bch.o
>  obj-$(CONFIG_MTD_NAND_IDS)		+= nand_ids.o nand_hynix.o

Thanks,
Brian
