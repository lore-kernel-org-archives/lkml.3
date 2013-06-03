Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3FCFtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:49:40 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:38385 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3FCFtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:49:36 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2013 01:49:35 EDT
Message-ID: <51AC2D20.3040703@atmel.com>
Date: Mon, 3 Jun 2013 13:44:00 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MTD: atmel_nand: using a stronger ECC is not dangerous
References: <1370010850-20860-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1370010850-20860-1-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/2013 10:34 PM, Richard Genoud wrote:
> We don't have to issue a warning when a stronger error correting
> capability is chosen.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Acked-by: Josh Wu <josh.wu@atmel.com>

Best Regards,
Josh Wu

> ---
>   drivers/mtd/nand/atmel_nand.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> index 2d23d29..2415cdc 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -1002,7 +1002,7 @@ static int __init atmel_pmecc_nand_init_params(struct platform_device *pdev,
>   		return err_no;
>   	}
>   
> -	if (cap != host->pmecc_corr_cap ||
> +	if (cap > host->pmecc_corr_cap ||
>   			sector_size != host->pmecc_sector_size)
>   		dev_info(host->dev, "WARNING: Be Caution! Using different PMECC parameters from Nand ONFI ECC reqirement.\n");
>   

