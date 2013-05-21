Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3EURtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:49:08 -0400
Received: from londo.lunn.ch ([80.238.139.98]:36889 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3EURtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:49:06 -0400
Date: Tue, 21 May 2013 19:48:49 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] ARM: dove: add gigabit ethernet and mvmdio
 device tree nodes
Message-ID: <20130521174849.GL26249@lunn.ch>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-7-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369154510-4927-7-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 06:41:44PM +0200, Sebastian Hesselbarth wrote:
> This patch adds orion-eth and mvmdio device tree nodes for DT enabled
> Dove boards. As there is only one ethernet controller on Dove, a default
> phy node is also added with a note to set its reg property on a per-board
> basis.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v3->v4:
> - convert to new device tree binding
> 
> Cc: David Miller <davem@davemloft.net>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove-cubox.dts |    7 +++++++
>  arch/arm/boot/dts/dove.dtsi      |   35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
> index 7e3065a..02618fa 100644
> --- a/arch/arm/boot/dts/dove-cubox.dts
> +++ b/arch/arm/boot/dts/dove-cubox.dts
> @@ -49,6 +49,13 @@
>  &uart0 { status = "okay"; };
>  &sata0 { status = "okay"; };
>  &i2c0 { status = "okay"; };
> +&mdio { status = "okay"; };
> +&eth { status = "okay"; };
> +
> +&ethphy {
> +	compatible = "marvell,88e1310";
> +	reg = <1>;
> +};
>  
>  &sdio0 {
>  	status = "okay";
> diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
> index 6cab468..8612658 100644
> --- a/arch/arm/boot/dts/dove.dtsi
> +++ b/arch/arm/boot/dts/dove.dtsi
> @@ -258,5 +258,40 @@
>  				dmacap,xor;
>  			};
>  		};
> +
> +		mdio: mdio-bus@72004 {
> +			compatible = "marvell,orion-mdio";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x72004 0x84>;
> +			interrupts = <30>;
> +			clocks = <&gate_clk 2>;
> +			status = "disabled";
> +
> +			ethphy: ethernet-phy {
> +				device-type = "ethernet-phy";
> +				/* set phy address in board file */
> +			};
> +		};
> +
> +		eth: ethernet-controller@72000 {
> +			compatible = "marvell,orion-eth";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x72000 0x4000>;
> +			clocks = <&gate_clk 2>;
> +			marvell,tx-checksum-limit = <1600>;
> +			status = "disabled";
> +
> +			ethernet-port@0 {
> +				device_type = "network";
> +				compatible = "marvell,orion-eth-port";
> +				reg = <0>;
> +				interrupts = <29>;
> +				/* overwrite MAC address in bootloader */
> +				local-mac-address = [00 00 00 00 00 00];

Hi Sebastian

Its probably a good idea to set the local administration bit in this
MAC address. i.e. first byte is 02.

    Andrew
