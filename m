Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaKKXXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:23:14 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:40165 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaKKXXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:23:12 -0500
Message-ID: <54629A5B.9050209@gmail.com>
Date: Wed, 12 Nov 2014 00:23:07 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] ARM: berlin: Add AHCI and SATA PHY nodes to BG2
References: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com> <1414664488-5911-1-git-send-email-sebastian.hesselbarth@gmail.com> <1414664488-5911-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1414664488-5911-5-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.10.2014 11:21, Sebastian Hesselbarth wrote:
> Add DT nodes for the AHCI controller and SATA PHY found on Marvell
> Berlin2 SoCs.
>
> Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied both DT patches to berlin/dt.

Sebastian

> ---
>   arch/arm/boot/dts/berlin2.dtsi | 39 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 39 insertions(+)
>
> diff --git a/arch/arm/boot/dts/berlin2.dtsi b/arch/arm/boot/dts/berlin2.dtsi
> index 9d7c810ebd0b..f39090491eb2 100644
> --- a/arch/arm/boot/dts/berlin2.dtsi
> +++ b/arch/arm/boot/dts/berlin2.dtsi
> @@ -246,6 +246,45 @@
>   			};
>   		};
>
> +		ahci: sata@e90000 {
> +			compatible = "marvell,berlin2-ahci", "generic-ahci";
> +			reg = <0xe90000 0x1000>;
> +			interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&chip CLKID_SATA>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			sata0: sata-port@0 {
> +				reg = <0>;
> +				phys = <&sata_phy 0>;
> +				status = "disabled";
> +			};
> +
> +			sata1: sata-port@1 {
> +				reg = <1>;
> +				phys = <&sata_phy 1>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		sata_phy: phy@e900a0 {
> +			compatible = "marvell,berlin2-sata-phy";
> +			reg = <0xe900a0 0x200>;
> +			clocks = <&chip CLKID_SATA>;
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			#phy-cells = <1>;
> +			status = "disabled";
> +
> +			sata-phy@0 {
> +				reg = <0>;
> +			};
> +
> +			sata-phy@1 {
> +				reg = <1>;
> +			};
> +		};
> +
>   		chip: chip-control@ea0000 {
>   			compatible = "marvell,berlin2-chip-ctrl";
>   			#clock-cells = <1>;
>

