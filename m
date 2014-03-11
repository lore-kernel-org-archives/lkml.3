Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaCKIjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:39:49 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46127 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaCKIjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:39:46 -0400
Date: Tue, 11 Mar 2014 08:39:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Erico Nunes <nunes.erico@gmail.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, b32955@freescale.com,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com
Subject: Re: [PATCH] mtd: nand: fix mention to CONFIG_MTD_NAND_ECC_BCH
Message-ID: <20140311083940.GK2839@lee--X1>
References: <1394512286-31481-1-git-send-email-nunes.erico@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394512286-31481-1-git-send-email-nunes.erico@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mention to CONFIG_MTD_ECC_BCH in the warning message can be confusing as this
> doesn't match the exact name of the configuration option.
> This warning showed up once to me when I was starting to set up BCH. After
> checking my .config file, it took a moment before realizing it is
> CONFIG_MTD_NAND_ECC_BCH instead of CONFIG_MTD_ECC_BCH.
> 
> Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 9715a7b..5a93787 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -3825,7 +3825,7 @@ int nand_scan_tail(struct mtd_info *mtd)
>  
>  	case NAND_ECC_SOFT_BCH:
>  		if (!mtd_nand_has_bch()) {
> -			pr_warn("CONFIG_MTD_ECC_BCH not enabled\n");
> +			pr_warn("CONFIG_MTD_NAND_ECC_BCH not enabled\n");
>  			BUG();
>  		}
>  		ecc->calculate = nand_bch_calculate_ecc;

Not sure if CONFIG options should be printed in the log at all, but
the correct option is better than an incorrect one. Seeing as
CONFIG_MTD_ECC_BCH doesn't actually exist:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
