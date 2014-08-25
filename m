Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaHYQrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:47:25 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33785 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHYQrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:47:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+crV38Ost4sxwq92tAPvoC
Date: Mon, 25 Aug 2014 09:47:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: computersforpeace@gmail.com, gregkh@linuxfoundation.org, nsekhar@ti.com,
        ezequiel.garcia@free-electrons.com, pekon@pek-sem.com,
        artem.bityutskiy@linux.intel.com, dwmw2@infradead.org,
        jg1.han@samsung.com, linux-mtd@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: nand: omap: Fix 1-bit Hamming code scheme,
 omap_calculate_ecc()
Message-ID: <20140825164706.GK17254@atomide.com>
References: <1407508028-12973-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407508028-12973-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140808 07:29]:
> commit 65b97cf6b8de introduced in v3.7 caused a regression
> by using a reversed CS_MASK thus causing omap_calculate_ecc to
> always fail. As the NAND base driver never checks for .calculate()'s
> return value, the zeroed ECC values are used as is without showing
> any error to the user. However, this won't work and the NAND device
> won't be guarded by any error code.
> 
> Fix the issue by using the correct mask.
> 
> Code was tested on omap3beagle using the following procedure
> - flash the primary bootloader (MLO) from the kernel to the first
> NAND partition using nandwrite.
> - boot the board from NAND. This utilizes OMAP ROM loader that
> relies on 1-bit Hamming code ECC.
> 
> Fixes: 65b97cf6b8de (mtd: nand: omap2: handle nand on gpmc)
> 
> Cc: <stable@vger.kernel.org>	[3.7+]
> Signed-off-by: Roger Quadros <rogerq@ti.com>

I'll apply this into omap-for-v3.17/fixes thanks.

Regards,

Tony

> ---
>  drivers/mtd/nand/omap2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index f0ed92e..e2b9b34 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -931,7 +931,7 @@ static int omap_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
>  	u32 val;
>  
>  	val = readl(info->reg.gpmc_ecc_config);
> -	if (((val >> ECC_CONFIG_CS_SHIFT)  & ~CS_MASK) != info->gpmc_cs)
> +	if (((val >> ECC_CONFIG_CS_SHIFT) & CS_MASK) != info->gpmc_cs)
>  		return -EINVAL;
>  
>  	/* read ecc result */
> -- 
> 1.8.3.2
> 
