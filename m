Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3JDO0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:26:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49871 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057Ab3JDO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:26:49 -0400
Date: Fri, 4 Oct 2013 15:26:45 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mark A. Greer" <mgreer@animalcreek.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/9] ARM: dts: Add SHAM data and documentation for
 AM33XX
Message-ID: <20131004142644.GI6999@e106331-lin.cambridge.arm.com>
References: <1380553986-15910-1-git-send-email-joelf@ti.com>
 <1380553986-15910-4-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380553986-15910-4-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:13:00PM +0100, Joel Fernandes wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> Add the generic AM33XX SHAM module's device tree data and
> enable it for the am335x-evm, am335x-evmsk, and am335x-bone
> platforms.  Also add Documentation file describing the data
> for the SHAM module.
> 
> [joelf@ti.com: Dropped interrupt-parrent property]
> CC: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  .../devicetree/bindings/crypto/omap-sham.txt       | 31 ++++++++++++++++++++++
>  arch/arm/boot/dts/am335x-bone.dts                  |  4 +++
>  arch/arm/boot/dts/am335x-evm.dts                   |  4 +++
>  arch/arm/boot/dts/am335x-evmsk.dts                 |  4 +++
>  arch/arm/boot/dts/am33xx.dtsi                      |  9 +++++++
>  5 files changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/omap-sham.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/omap-sham.txt b/Documentation/devicetree/bindings/crypto/omap-sham.txt
> new file mode 100644
> index 0000000..b97710f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/omap-sham.txt
> @@ -0,0 +1,31 @@
> +OMAP SoC SHA crypto Module
> +
> +Required properties:
> +
> +- compatible : Should contain entries for this and backward compatible
> +  SHAM versions:
> +  - "ti,omap2-sham" for OMAP2 & OMAP3.
> +  - "ti,omap4-sham" for OMAP4 and AM33XX.
> +  Note that these two versions are incompatible.
> +- ti,hwmods: Name of the hwmod associated with the SHAM module
> +- reg : Offset and length of the register set for the module
> +- interrupt-parent : the phandle for the interrupt controller that
> +  services interrupts for this module.

I don't think this is strictly speaking necessary -- it's mostly going
to be implicit (it is in the dtsi below). As this is a standard
property, you don't need to document it here.

> +- interrupts : the interrupt number for the SHAM module.

Sorry, I missed this last time, but this should be interrupt-specifier
rather than interrupt number.

Otherwise, this looks good to me. With the fixups above:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> +
> +Optional properties:
> +- dmas: DMA specifier for the rx dma. See the DMA client binding,
> +	Documentation/devicetree/bindings/dma/dma.txt
> +- dma-names: DMA request name. Should be "rx" if a dma is present.
> +
> +Example:
> +	/* AM335x */
> +	sham: sham@53100000 {
> +		compatible = "ti,omap4-sham";
> +		ti,hwmods = "sham";
> +		reg = <0x53100000 0x200>;
> +		interrupt-parent = <&intc>;
> +		interrupts = <109>;
> +		dmas = <&edma 36>;
> +		dma-names = "rx";
> +	};
> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index 0d63348..8a9802e 100644
> --- a/arch/arm/boot/dts/am335x-bone.dts
> +++ b/arch/arm/boot/dts/am335x-bone.dts
> @@ -19,3 +19,7 @@
>  &mmc1 {
>  	vmmc-supply = <&ldo3_reg>;
>  };
> +
> +&sham {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index 23b0a3e..d59e51c 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -522,3 +522,7 @@
>  	status = "okay";
>  	vmmc-supply = <&vmmc_reg>;
>  };
> +
> +&sham {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
> index bc93895..d45a330 100644
> --- a/arch/arm/boot/dts/am335x-evmsk.dts
> +++ b/arch/arm/boot/dts/am335x-evmsk.dts
> @@ -424,3 +424,7 @@
>  	status = "okay";
>  	vmmc-supply = <&vmmc_reg>;
>  };
> +
> +&sham {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 553adc6..299710b 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -710,5 +710,14 @@
>  			#size-cells = <1>;
>  			status = "disabled";
>  		};
> +
> +		sham: sham@53100000 {
> +			compatible = "ti,omap4-sham";
> +			ti,hwmods = "sham";
> +			reg = <0x53100000 0x200>;
> +			interrupts = <109>;
> +			dmas = <&edma 36>;
> +			dma-names = "rx";
> +		};
>  	};
>  };
> -- 
> 1.8.1.2
> 
> 
