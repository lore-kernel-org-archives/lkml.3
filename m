Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaBFNbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:31:23 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50078 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbaBFNbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:31:21 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-d9-52f38ea79431
Message-id: <52F38EA4.10805@samsung.com>
Date: Thu, 06 Feb 2014 14:31:16 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com, balbi@ti.com,
        cpgs@samsung.com
Subject: Re: [PATCH 1/2 v3] i2c: exynos5: add support for HSI2C on Exynos5260
 SoC
References: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
 <1391688408-8077-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1391688408-8077-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xq7rL+z4HGazYyWZx8H69xd3nhxkt
	Xh7StDgw+yGrxaszG9ksehdcZbPY9Pgaq0XH3y+MFpd3zWGzmHF+H5PFom3/mS2e/Ady973e
	yuzA67Fz1l12j81L6j3Oz1jI6NH/18Cjb8sqRo+fL3U8jt/YzuTxeZNcAEcUl01Kak5mWWqR
	vl0CV8bH9rtsBRNlKib9vMnYwHhcrIuRk0NCwESifc5WFghbTOLCvfVsXYxcHEICSxklJjV8
	YYVwPjNKNLRdZQSp4hXQkDj78zVTFyMHB4uAqsTu3aIgYTYBNYnPDY/YQGxRgQiJv/PWQ5UL
	SvyYfA9sgYhAicSOJxfA4swC/UwSX05IgtjCAsESEzY9ZYHY1cAocbi1H2wQp4CrxPtt06Aa
	rCVWTtoGZctLbF7zlnkCo8AsJDtmISmbhaRsASPzKkbR1NLkguKk9FxDveLE3OLSvHS95Pzc
	TYyQuPmyg3HxMatDjAIcjEo8vBvWfwoSYk0sK67MPcQowcGsJMKb2vQ5SIg3JbGyKrUoP76o
	NCe1+BAjEwenVAOjtXRauYV5ooZfVcmqmhv3luWYidmq56of8Lgut1HzV+oTz5l72Rm0zNjD
	dp7+KHnNWufIu0VPF5eurOf2KXTd0P5k9iWXXIU1T9J3PD858+JOob1bJXde+Hnw4ot5x6xP
	dgp2vJ+3aslUQ/sp11JCnf/8Kp/Hb+Lfsr108/4jaY/L573aZdHzUYmlOCPRUIu5qDgRAF3j
	JYd5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 06.02.2014 13:06, Naveen Krishna Chatradhi wrote:
> This patch implements a variant struct to handle the differences
> (like fifo_depths) in the HSI2C modules across SoCs.
>
> Adds a new compatible to support HSI2C module on Exynos5260.
> Also resets the module as an init sequence (Needed by Exynos5260).
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v2:
> 1. Used variant struct as suggested by Tomasz Figa.
> 2. Change compatible strings from samsung,exynos5-hsi2c to
>     samsung,exynos5250-hsi2c based on the first SoC to see the feature.
> 3. Using reset as init sequences.
> 4. Merged the 2 patches into one.
>
>   .../devicetree/bindings/i2c/i2c-exynos5.txt        |    8 ++-
>   drivers/i2c/busses/i2c-exynos5.c                   |   64 ++++++++++++++++----
>   2 files changed, 58 insertions(+), 14 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> index 056732c..5bc4998 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> @@ -5,7 +5,11 @@ at various speeds ranging from 100khz to 3.4Mhz.
>
>   Required properties:
>     - compatible: value should be.
> -      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.

Device tree bindings need to be backwards compatible, so you need to 
keep this compatible string supported, just marked as (DEPRECATED).

Driver-wise, it will use the same driver data / variant struct as 
"samsung,exynos5250-hsi2c", just one more entry in OF match table is needed.

> +	-> "samsung,exynos5250-hsi2c", for i2c compatible with HSI2C available
> +				on Exynos5250 and Exynos5420 SoCs.
> +	-> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
> +				on Exynos5260 SoCs.
> +
>     - reg: physical base address of the controller and length of memory mapped
>       region.
>     - interrupts: interrupt number to the cpu.
> @@ -26,7 +30,7 @@ Optional properties:
>   Example:
>
>   hsi2c@12ca0000 {
> -	compatible = "samsung,exynos5-hsi2c";
> +	compatible = "samsung,exynos5250-hsi2c";
>   	reg = <0x12ca0000 0x100>;
>   	interrupts = <56>;
>   	clock-frequency = <100000>;

[snip]

> @@ -483,6 +514,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
>   	u32 i2c_auto_conf = 0;
>   	u32 fifo_ctl;
>   	unsigned long flags;
> +	unsigned short trig_lvl;
>
>   	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
>   	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
> @@ -493,13 +525,19 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
>
>   		i2c_auto_conf = HSI2C_READ_WRITE;
>
> -		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
> +		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
> +			(i2c->variant->fifo_depth * 3/4) : i2c->msg->len;
> +		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(trig_lvl);
> +

This is a rather serious semantic change, that doesn't look to belong to 
this patch. If this is needed, it should be done in a separate patch.

>   		int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
>   			HSI2C_INT_TRAILING_EN);
>   	} else {
>   		i2c_ctl |= HSI2C_TXCHON;
>
> -		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(HSI2C_DEF_RXFIFO_LVL);
> +		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
> +			(i2c->variant->fifo_depth * 1/4) : i2c->msg->len;
> +		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(trig_lvl);
> +

Ditto.

Best regards,
Tomasz
