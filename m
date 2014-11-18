Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaKRTiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:38:09 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53708 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaKRTiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:38:07 -0500
Message-ID: <546BA01A.6050707@gmail.com>
Date: Tue, 18 Nov 2014 20:38:02 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Peter.Chen@freescale.com, balbi@ti.com, p.zabel@pengutronix.de
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/13] ARM: dts: berlin: add BG2CD nodes for USB support
References: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com> <1416231347-27193-13-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1416231347-27193-13-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 14:35, Antoine Tenart wrote:
> From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> Adds nodes describing the Marvell Berlin BG2CD USB PHY and USB. The BG2CD
> SoC has 2 USB ChipIdea controllers, with usb0 host-only and usb1 dual-role
> capable.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Applied to berlin/dt with usb-phy nodes reordered correctly (ethernet
nodes came in between in the meantime).

Thanks!

> ---
>   arch/arm/boot/dts/berlin2cd.dtsi | 36 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 36 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2cd.dtsi b/arch/arm/boot/dts/berlin2cd.dtsi
> index 68f7032b4686..af5e628547ce 100644
> --- a/arch/arm/boot/dts/berlin2cd.dtsi
> +++ b/arch/arm/boot/dts/berlin2cd.dtsi
> @@ -66,6 +66,22 @@
>   			clocks = <&chip CLKID_TWD>;
>   		};
>
> +		usb_phy0: usb-phy@b74000 {
> +			compatible = "marvell,berlin2cd-usb-phy";
> +			reg = <0xb74000 0x128>;
> +			#phy-cells = <0>;
> +			resets = <&chip 0x178 23>;
> +			status = "disabled";
> +		};
> +
> +		usb_phy1: usb-phy@b78000 {
> +			compatible = "marvell,berlin2cd-usb-phy";
> +			reg = <0xb78000 0x128>;
> +			#phy-cells = <0>;
> +			resets = <&chip 0x178 24>;
> +			status = "disabled";
> +		};
> +
>   		apb@e80000 {
>   			compatible = "simple-bus";
>   			#address-cells = <1>;
> @@ -242,6 +258,26 @@
>   			};
>   		};
>
> +		usb0: usb@ed0000 {
> +			compatible = "chipidea,usb2";
> +			reg = <0xed0000 0x200>;
> +			interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&chip CLKID_USB0>;
> +			phys = <&usb_phy0>;
> +			phy-names = "usb-phy";
> +			status = "disabled";
> +		};
> +
> +		usb1: usb@ee0000 {
> +			compatible = "chipidea,usb2";
> +			reg = <0xee0000 0x200>;
> +			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&chip CLKID_USB1>;
> +			phys = <&usb_phy1>;
> +			phy-names = "usb-phy";
> +			status = "disabled";
> +		};
> +
>   		apb@fc0000 {
>   			compatible = "simple-bus";
>   			#address-cells = <1>;
>

