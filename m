Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3G2Mgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:36:54 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:44121 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3G2Mgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:36:53 -0400
Message-ID: <51F661DE.1070106@gmail.com>
Date: Mon, 29 Jul 2013 14:36:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ARM: dove: add MBus DT node
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375101114-28858-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1375101114-28858-4-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 02:31 PM, Sebastian Hesselbarth wrote:
> This adds a MBus node including ranges and pcie apertures required later.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
>   arch/arm/boot/dts/dove.dtsi |   19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> index 397674c..bdda016 100644
> --- a/arch/arm/boot/dts/dove.dtsi
> +++ b/arch/arm/boot/dts/dove.dtsi
> @@ -29,6 +29,20 @@
>   		marvell,tauros2-cache-features = <0>;
>   	};
>
> +	mbus {
> +		compatible = "marvell,dove-mbus", "marvell,mbus", "simple-bus";
> +		#address-cells = <2>;
> +		#size-cells = <1>;
> +		pcie-mem-aperture = <0xe0000000 0x10000000>; /* 256M MEM space */
> +		pcie-io-aperture  = <0xf2000000 0x00200000>; /*   2M I/O space */

Actually, current v9 of the mbus patch set still requires "controller"
property to match the corresponding controller node. I had a short
discussion with Ezequiel to possibly just use of_find_compatible_node
and blindly assumed post-v8 will already use it.

I will re-post the final patch set anyway on what mbus binding will be
merged for v3.12.

Sebastian

> +		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x0100000   /* MBUS regs  1M */
> +			  MBUS_ID(0xf0, 0x02) 0 0xf1800000 0x1000000   /* AXI  regs 16M */
> +			  MBUS_ID(0x01, 0xfd) 0 0xf8000000 0x8000000   /* BootROM  128M */
> +			  MBUS_ID(0x03, 0x01) 0 0xc8000000 0x0100000   /* CESA SRAM  1M */
> +			  MBUS_ID(0x0d, 0x00) 0 0xf0000000 0x0100000>; /* PMU  SRAM  1M */
> +	};
> +
>   	soc@f1000000 {
>   		compatible = "simple-bus";
>   		#address-cells = <1>;
> @@ -44,6 +58,11 @@
>   		          0xf2100000 0xf2100000 0x0100000   /* PCIe0 I/O   1M */
>   		          0xf8000000 0xf8000000 0x8000000>; /* BootROM   128M */
>
> +		mbusc: mbus-ctrl@20000 {
> +			compatible = "marvell,mbus-controller";
> +			reg = <0x20000 0x80>, <0x800100 0x8>;
> +		};
> +
>   		timer: timer@20300 {
>   			compatible = "marvell,orion-timer";
>   			reg = <0x20300 0x20>;
>

