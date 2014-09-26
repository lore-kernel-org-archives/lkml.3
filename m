Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaIZRZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:25:24 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:47325 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbaIZRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:25:18 -0400
Message-ID: <5425A178.4050501@cogentembedded.com>
Date: Fri, 26 Sep 2014 21:25:12 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com
CC: thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 09/10] ARM: dts: berlin: add the Ethernet node
References: <1411742036-23520-1-git-send-email-antoine.tenart@free-electrons.com> <1411742036-23520-10-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1411742036-23520-10-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/26/2014 06:33 PM, Antoine Tenart wrote:

> This patch adds the Ethernet node, enabling the network unit on Berlin
> BG2Q SoCs.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   arch/arm/boot/dts/berlin2q.dtsi | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)

> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 902eddb19cd8..d442b22fd1ea 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -114,6 +114,23 @@
>   			#interrupt-cells = <3>;
>   		};
>
> +		eth0: ethernet@b90000 {
> +			compatible = "marvell,pxa168-eth";
> +			reg = <0xb90000 0x10000>;
> +			clocks = <&chip CLKID_GETH0>;
> +			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
> +			/* set by bootloader */
> +			local-mac-address = [00 00 00 00 00 00];
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			phy-handle = <&ethphy0>;
> +			status = "disabled";
> +
> +			ethphy0: ethernet-phy@0 {
> +				reg = <0>;
> +			};
> +		};
> +

    Hm, is the PHY internal to the Ethernet controller?

WBR, Sergei

