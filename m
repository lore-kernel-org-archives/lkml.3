Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbbAGOWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:22:36 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56730 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbAGOWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:22:34 -0500
Message-ID: <54AD4126.6030807@gmail.com>
Date: Wed, 07 Jan 2015 15:22:30 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Jisheng Zhang <jszhang@marvell.com>, mturquette@linaro.org,
        sboyd@codeaurora.org, alexandre.belloni@free-electrons.com,
        antoine.tenart@free-electrons.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: dts: berlin: fix io clk and add missing core
 clk for BG2Q sdhci2 host
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com> <1420016272-6789-2-git-send-email-jszhang@marvell.com>
In-Reply-To: <1420016272-6789-2-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.12.2014 09:57, Jisheng Zhang wrote:
> On BG2Q, the sdhci2 host uses nfcecc for "io" clk and nfc for "core" clk.
> The shdci2 can't work Without this patch due to the "core" clk is gated.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Cc: stable@vger.kernel.org # 3.16+

Applied to berlin/fixes.

Thanks!

> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 35253c9..903f3bb 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -83,7 +83,8 @@
>   			compatible = "mrvl,pxav3-mmc";
>   			reg = <0xab1000 0x200>;
>   			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
> -			clocks = <&chip CLKID_SDIO1XIN>;
> +			clocks = <&chip CLKID_NFC_ECC>, <&chip CLKID_NFC>;
> +			clock-names = "io", "core";
>   			status = "disabled";
>   		};
>
>

