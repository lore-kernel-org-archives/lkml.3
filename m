Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab3A1CEr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:04:47 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:52615
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757180Ab3A1CEp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:04:45 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzc89bh1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch35h1155h)
Message-ID: <5105DCAE.8090907@freescale.com>
Date: Mon, 28 Jan 2013 10:04:30 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <computersforpeace@gmail.com>, <shmulik.ladkani@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] mtd: add a new table for the unparsable nand chips
References: <1359007901-26464-1-git-send-email-b32955@freescale.com> <1359007901-26464-3-git-send-email-b32955@freescale.com>
In-Reply-To: <1359007901-26464-3-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年01月24日 14:11, Huang Shijie 写道:
> We have 4 Toshiba nand chips which can not be parsed out by the
> id data.  Add a new table for the unparsable nand chips.
>
> It makes mess if we add these entries to the nand_flash_ids table.
> The entries in the nand_flash_ids stands for a class of nand chips.
> But the unparsable nand chips are just some singular chips.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/mtd/nand/nand_ids.c |   22 ++++++++++++++++++++++
>  include/linux/mtd/nand.h    |    1 +
>  2 files changed, 23 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
> index 9dc2e54..c1e32d2 100644
> --- a/drivers/mtd/nand/nand_ids.c
> +++ b/drivers/mtd/nand/nand_ids.c
> @@ -11,6 +11,28 @@
>  #include <linux/module.h>
>  #include <linux/mtd/nand.h>
>  #include <linux/sizes.h>
> +#include <linux/sizes.h>
sorry, i added the same header twice.

> +
> +/* This table uses the full ID data as the keyword. */
> +struct nand_flash_dev nand_flash_full_ids[] = {
> +	/* TOSHIBA */
> +	{"TC58NVG2S0F 4G 3.3V 8-bit ",
> +		{0x98, 0xdc, 0x90, 0x26, 0x76, 0x15, 0x01, 0x08},
> +			SZ_4K, SZ_512, SZ_256K, 0, 8, 224},
> +	{"TC58NVG3S0F 8G 3.3V 8-bit ",
> +		{0x98, 0xd3, 0x90, 0x26, 0x76, 0x15, 0x02, 0x08},
> +			SZ_4K, SZ_1K, SZ_256K, 0, 8, 232},
> +	{"TC58NVG5D2 32G 3.3V 8-bit ",
> +		{0x98, 0xd7, 0x94, 0x32, 0x76, 0x56, 0x09, 0x00},
> +			SZ_8K, SZ_4K, SZ_1M, 0, 8, 640},
> +	{"TC58NVG6D2 64G 3.3V 8-bit ",
> +		{0x98, 0xde, 0x94, 0x82, 0x76, 0x56, 0x04, 0x20},
> +			SZ_8K, SZ_8K, SZ_2M, 0, 8, 640},
> +
> +	/* end here */
> +	{NULL,}
> +};
> +
>  
>  /*
>  *	Chip ID list
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index 5293447..346a389 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -620,6 +620,7 @@ struct nand_manufacturers {
>  };
>  
>  extern struct nand_flash_dev nand_flash_ids[];
> +extern struct nand_flash_dev nand_flash_full_ids[];
>  extern struct nand_manufacturers nand_manuf_ids[];
>  
>  extern int nand_scan_bbt(struct mtd_info *mtd, struct nand_bbt_descr *bd);


