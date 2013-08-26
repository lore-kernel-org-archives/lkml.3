Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3HZIdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:33:40 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:53220 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3HZIdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:33:38 -0400
Message-ID: <521B12DD.8010505@baylibre.com>
Date: Mon, 26 Aug 2013 10:33:33 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: tony@atomide.com, Joel Fernandes <joelf@ti.com>, santosh.shilimkar@ti.com,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Matt Porter <mdp@ti.com>, Matt Porter <mporter@ti.com>,
        Joel A Fernandes <joelagnel@ti.com>
Subject: Re: [PATCH] ARM: dts: add AM33XX EDMA support
References: <1377284808-32412-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1377284808-32412-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

Is this patch different from that one:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg92176.html

Lokesh just pointed me this patch because it was missing for the 
SHAM/AES series from Mark Greer.

Bottom-line, I've just applied the original one along with a second one 
that was adding EDMA in SPI.

Regards,
Benoit


On 23/08/2013 21:06, Sebastian Andrzej Siewior wrote:
> From: Matt Porter <mdp@ti.com>
>
> Adds AM33XX EDMA support to the am33xx.dtsi as documented in
> Documentation/devicetree/bindings/dma/ti-edma.txt
>
> Joel: Drop DT entries that are non-hardware-description for now as discussed in [1]
>
> [1] https://patchwork.kernel.org/patch/2226761/
>
> Signed-off-by: Matt Porter <mporter@ti.com>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Could someone please pick this up?
>
>   arch/arm/boot/dts/am33xx.dtsi | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 38b446b..784f774 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -96,6 +96,18 @@
>   			reg = <0x48200000 0x1000>;
>   		};
>
> +		edma: edma@49000000 {
> +			compatible = "ti,edma3";
> +			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> +			reg =	<0x49000000 0x10000>,
> +				<0x44e10f90 0x10>;
> +			interrupts = <12 13 14>;
> +			#dma-cells = <1>;
> +			dma-channels = <64>;
> +			ti,edma-regions = <4>;
> +			ti,edma-slots = <256>;
> +		};
> +
>   		gpio0: gpio@44e07000 {
>   			compatible = "ti,omap4-gpio";
>   			ti,hwmods = "gpio1";
>

