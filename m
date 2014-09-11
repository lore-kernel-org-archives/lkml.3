Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaIKBiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 21:38:14 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:59389 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIKBiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 21:38:13 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 10 Sep 2014 21:38:11 -0400
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: bcousson@baylibre.com, tony@atomide.com, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: dts: dra7: Add CPSW and MDIO module nodes
 for dra7
Message-ID: <20140911013811.GB17692@csclub.uwaterloo.ca>
References: <1410356247-25925-1-git-send-email-mugunthanvnm@ti.com>
 <1410356247-25925-2-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410356247-25925-2-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 07:07:26PM +0530, Mugunthan V N wrote:
> Add CPSW and MDIO related device tree data for DRA7XX and made as status
> disabled. Phy-id, pinmux for active and sleep state needs to be added in
> board dts files and enable the CPSW device.
> 
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> ---
>  arch/arm/boot/dts/dra7.dtsi | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index d678152..8d79321 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -34,6 +34,8 @@
>  		serial3 = &uart4;
>  		serial4 = &uart5;
>  		serial5 = &uart6;
> +		ethernet0 = &cpsw_emac0;
> +		ethernet1 = &cpsw_emac1;
>  	};
>  
>  	timer {
> @@ -1262,6 +1264,63 @@
>  			ti,irqs-skip = <10 133 139 140>;
>  			ti,irqs-safe-map = <0>;
>  		};
> +
> +		mac: ethernet@4a100000 {
> +			compatible = "ti,cpsw";
> +			ti,hwmods = "gmac";
> +			cpdma_channels = <8>;
> +			ale_entries = <1024>;
> +			bd_ram_size = <0x2000>;
> +			no_bd_ram = <0>;
> +			rx_descs = <64>;
> +			mac_control = <0x20>;
> +			slaves = <2>;

How am I supposed to override this in the board dtb when my board only
uses 1 slave?

> +			active_slave = <0>;
> +			cpts_clock_mult = <0x80000000>;
> +			cpts_clock_shift = <29>;
> +			reg = <0x48484000 0x1000
> +			       0x48485200 0x2E00>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			/*
> +			 * rx_thresh_pend
> +			 * rx_pend
> +			 * tx_pend
> +			 * misc_pend
> +			 */
> +			interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
> +				     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
> +			ranges;
> +			status = "disabled";
> +
> +			davinci_mdio: mdio@48485000 {
> +				compatible = "ti,davinci_mdio";
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				ti,hwmods = "davinci_mdio";
> +				bus_freq = <1000000>;
> +				reg = <0x48485000 0x100>;
> +			};
> +
> +			cpsw_emac0: slave@48480200 {
> +				/* Filled in by U-Boot */
> +				mac-address = [ 00 00 00 00 00 00 ];
> +			};
> +
> +			cpsw_emac1: slave@48480300 {
> +				/* Filled in by U-Boot */
> +				mac-address = [ 00 00 00 00 00 00 ];
> +			};

Should I then be setting this to disabled from my board file?  Or does
the disabled for the ethernet overall take care of that?

> +			phy_sel: cpsw-phy-sel@4a002554 {
> +				compatible = "ti,dra7xx-cpsw-phy-sel";
> +				reg= <0x4a002554 0x4>;
> +				reg-names = "gmii-sel";
> +			};

I guess the board file would have to disable that too (we won't have a
phy given we are connecting to a switch chip).

> +		};
> +
>  	};
>  };

-- 
Len Sorensen
