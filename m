Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaG3JhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:37:05 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:35709 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751593AbaG3JhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:37:03 -0400
Message-ID: <53D8BC92.4050907@atmel.com>
Date: Wed, 30 Jul 2014 17:36:18 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Raphael Poggi <poggi.raph@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: atmel_nand: increase chip_delay
References: <1406640447-9080-1-git-send-email-poggi.raph@gmail.com>
In-Reply-To: <1406640447-9080-1-git-send-email-poggi.raph@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Raphael

On 7/29/2014 9:27 PM, Raphael Poggi wrote:
> Some nand with 8k page size like Micron MT29F32G08ABAAAWP need more than 20us.
>
> Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
> ---
>   drivers/mtd/nand/atmel_nand.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> index e321c56..77bd877 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -2099,7 +2099,7 @@ static int atmel_nand_probe(struct platform_device *pdev)
>   	}
>   
>   	nand_chip->ecc.mode = host->board.ecc_mode;
> -	nand_chip->chip_delay = 20;		/* 20us command delay time */
> +	nand_chip->chip_delay = 40;		/* 40us command delay time */
>   
>   	if (host->board.bus_width_16)	/* 16-bit bus width */
>   		nand_chip->options |= NAND_BUSWIDTH_16;

I just post a patch [1] days ago which does almost the same thing to 
support 4k-page nand flash.
personally I am fine with your patch.

Brain, you only need to take care this patch. And drop my patch [1].

[1] http://patchwork.ozlabs.org/patch/372406/

Thanks.
Best Regards,
Josh Wu


