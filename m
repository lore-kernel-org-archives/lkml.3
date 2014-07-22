Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaGVDWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 23:22:21 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43043 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaGVDWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 23:22:19 -0400
Date: Mon, 21 Jul 2014 20:21:14 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/2] mxc_nand: fix err_limit and err_mask
Message-ID: <20140722032114.GA28323@ld-irv-0074>
References: <1403815368-29469-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403815368-29469-1-git-send-email-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

Since I had a few comments for changes on patch 2, might as well comment
here...

On Thu, Jun 26, 2014 at 10:42:47PM +0200, Michael Grzeschik wrote:
> This patch fixes the error detection limits for the used
> eccsize of the 1, 4 and 8 bit eccmode.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/mtd/nand/mxc_nand.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
> index cb6c845..7fd495e 100644
> --- a/drivers/mtd/nand/mxc_nand.c
> +++ b/drivers/mtd/nand/mxc_nand.c
> @@ -657,10 +657,14 @@ static int mxc_nand_correct_data_v2_v3(struct mtd_info *mtd, u_char *dat,
>  	u32 ecc_stat, err;
>  	int no_subpages = 1;
>  	int ret = 0;
> -	u8 ecc_bit_mask, err_limit;
> +	u8 ecc_bit_mask, err_limit = 0x1;
>  
> -	ecc_bit_mask = (host->eccsize == 4) ? 0x7 : 0xf;
> -	err_limit = (host->eccsize == 4) ? 0x4 : 0x8;
> +	ecc_bit_mask = 0xf;
> +
> +	if (host->eccsize == 4)
> +		err_limit = 0x2;
> +	else if (host->eccsize == 8)
> +		err_limit = 0x4;

This would be a little more obvious as a switch statement.

But please do address my comments on patch 2 (or at least reply, if you
have questions).

>  
>  	no_subpages = mtd->writesize >> 9;
>  

Thanks,
Brian
