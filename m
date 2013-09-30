Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3I3Ps4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:48:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:20529 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3I3Psy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:48:54 -0400
Message-ID: <52499D66.9070203@atmel.com>
Date: Mon, 30 Sep 2013 17:48:54 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: Andrew Victor <linux@maxim.org.za>, <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] ARM: at91: cam60: fix incorrect placement of __initdata
 tag
References: <4748525.slmbI8ubRr@amdc1032>
In-Reply-To: <4748525.slmbI8ubRr@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/2013 17:38, Bartlomiej Zolnierkiewicz :
> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.

Yes, okay. But please do not mix the removal of white lines with your 
modification.

> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Anyway, no need to resend it:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> v2:
> - use __initdata as it is OK to do it
>
>   arch/arm/mach-at91/board-cam60.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
> index ade948b..ecabbed 100644
> --- a/arch/arm/mach-at91/board-cam60.c
> +++ b/arch/arm/mach-at91/board-cam60.c
> @@ -108,16 +108,14 @@ static struct spi_board_info cam60_spi_devices[] __initdata = {
>   #endif
>   };
>
> -
>   /*
>    * MACB Ethernet device
>    */
> -static struct __initdata macb_platform_data cam60_macb_data = {
> +static struct macb_platform_data cam60_macb_data __initdata = {
>   	.phy_irq_pin	= AT91_PIN_PB5,
>   	.is_rmii	= 0,
>   };
>
> -
>   /*
>    * NAND Flash
>    */
>


-- 
Nicolas Ferre
