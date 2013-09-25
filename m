Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3IYHSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:18:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:28836 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3IYHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:18:12 -0400
Message-ID: <52428E33.6010306@atmel.com>
Date: Wed, 25 Sep 2013 09:18:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: at91: sama5d: add the PWM clock
References: <1380043832-26600-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1380043832-26600-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I modify the subject: s/sama5d/sama5d3/ and push it to our
at91-3.13-soc branch on:
https://github.com/at91linux/linux-at91/commits/at91-3.13-soc

With:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, bye,

On 24/09/2013 19:30, Alexandre Belloni :
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/mach-at91/sama5d3.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
> index 4012797..8e43e8d 100644
> --- a/arch/arm/mach-at91/sama5d3.c
> +++ b/arch/arm/mach-at91/sama5d3.c
> @@ -241,6 +241,11 @@ static struct clk tdes_clk = {
>   	.pid		= SAMA5D3_ID_TDES,
>   	.type		= CLK_TYPE_PERIPHERAL,
>   };
> +static struct clk pwm_clk = {
> +	.name		= "pwm_clk",
> +	.pid		= SAMA5D3_ID_PWM,
> +	.type		= CLK_TYPE_PERIPHERAL,
> +};
>
>   static struct clk *periph_clocks[] __initdata = {
>   	&pioA_clk,
> @@ -281,6 +286,7 @@ static struct clk *periph_clocks[] __initdata = {
>   	&sha_clk,
>   	&aes_clk,
>   	&tdes_clk,
> +	&pwm_clk,
>   };
>
>   static struct clk pck0 = {
> @@ -345,6 +351,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
>   	CLKDEV_CON_DEV_ID("sha_clk", "f8034000.sha", &sha_clk),
>   	CLKDEV_CON_DEV_ID("aes_clk", "f8038000.aes", &aes_clk),
>   	CLKDEV_CON_DEV_ID("tdes_clk", "f803c000.tdes", &tdes_clk),
> +	CLKDEV_CON_DEV_ID(NULL, "f002c000.pwm", &pwm_clk),
>   };
>
>   static void __init sama5d3_register_clocks(void)
>


-- 
Nicolas Ferre
