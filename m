Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaIHIfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:35:08 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50705 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaIHIfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:35:06 -0400
X-Originating-IP: 50.43.15.134
Date: Mon, 8 Sep 2014 01:34:48 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] mtd: denali: remove unnecessary parentheses
Message-ID: <20140908083443.GC5361@thin>
References: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
 <1410163813-31783-7-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410163813-31783-7-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 05:10:12PM +0900, Masahiro Yamada wrote:
> We should use parentheses only when they are necessary
> or they really improve the readability.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

This seems fine; none of these parentheses are needed, since the
relative precedence of the relevant operators is always clear.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> 
>  drivers/mtd/nand/denali.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
> index d37c2e1..ed37b76 100644
> --- a/drivers/mtd/nand/denali.c
> +++ b/drivers/mtd/nand/denali.c
> @@ -267,10 +267,10 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
>  
>  	acc_clks = CEIL_DIV(Trea[mode], CLK_X);
>  
> -	while (((acc_clks * CLK_X) - Trea[mode]) < 3)
> +	while (acc_clks * CLK_X - Trea[mode] < 3)
>  		acc_clks++;
>  
> -	if ((data_invalid - acc_clks * CLK_X) < 2)
> +	if (data_invalid - acc_clks * CLK_X < 2)
>  		dev_warn(denali->dev, "%s, Line %d: Warning!\n",
>  			__FILE__, __LINE__);
>  
> @@ -285,7 +285,7 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
>  		cs_cnt = 1;
>  
>  	if (Tcea[mode]) {
> -		while (((cs_cnt * CLK_X) + Trea[mode]) < Tcea[mode])
> +		while (cs_cnt * CLK_X + Trea[mode] < Tcea[mode])
>  			cs_cnt++;
>  	}
>  
> @@ -295,8 +295,8 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
>  #endif
>  
>  	/* Sighting 3462430: Temporary hack for MT29F128G08CJABAWP:B */
> -	if ((ioread32(denali->flash_reg + MANUFACTURER_ID) == 0) &&
> -		(ioread32(denali->flash_reg + DEVICE_ID) == 0x88))
> +	if (ioread32(denali->flash_reg + MANUFACTURER_ID) == 0 &&
> +		ioread32(denali->flash_reg + DEVICE_ID) == 0x88)
>  		acc_clks = 6;
>  
>  	iowrite32(acc_clks, denali->flash_reg + ACC_CLKS);
> @@ -577,7 +577,7 @@ static void denali_set_intr_modes(struct denali_nand_info *denali,
>   */
>  static inline bool is_flash_bank_valid(int flash_bank)
>  {
> -	return (flash_bank >= 0 && flash_bank < 4);
> +	return flash_bank >= 0 && flash_bank < 4;
>  }
>  
>  static void denali_irq_init(struct denali_nand_info *denali)
> @@ -1103,7 +1103,7 @@ static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
>  				"timeout on write_page (type = %d)\n",
>  				raw_xfer);
>  		denali->status =
> -			(irq_status & INTR_STATUS__PROGRAM_FAIL) ?
> +			irq_status & INTR_STATUS__PROGRAM_FAIL ?
>  			NAND_STATUS_FAIL : PASS;
>  	}
>  
> @@ -1296,7 +1296,7 @@ static int denali_erase(struct mtd_info *mtd, int page)
>  	irq_status = wait_for_irq(denali, INTR_STATUS__ERASE_COMP |
>  					INTR_STATUS__ERASE_FAIL);
>  
> -	return (irq_status & INTR_STATUS__ERASE_FAIL) ? NAND_STATUS_FAIL : PASS;
> +	return irq_status & INTR_STATUS__ERASE_FAIL ? NAND_STATUS_FAIL : PASS;
>  }
>  
>  static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
> -- 
> 1.9.1
> 
