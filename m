Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbaBUQjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:39:31 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35425 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbaBUQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:39:29 -0500
Date: Fri, 21 Feb 2014 11:39:23 -0500
From: Matt Porter <mporter@linaro.org>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 8/8] ARM: brcmstb: dts: add a reference DTS for
 Broadcom 7445
Message-ID: <20140221163923.GL5038@beef>
References: <1391463041-15241-1-git-send-email-marc.ceeeee@gmail.com>
 <1391463041-15241-9-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391463041-15241-9-git-send-email-marc.ceeeee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:30:41PM -0800, Marc Carino wrote:
> Add a sample DTS which will allow bootup of a board populated
> with the BCM7445 chip.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  arch/arm/boot/dts/bcm7445.dts |  111 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 111 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/bcm7445.dts

Looking forward, I suspect you are going to have to move to a
bcm7445.dtsi with your board specific implementations in something like
bcm7445-myrefbrd.dts. It's probably better to split this now to
encourage inclusion of the common SoC nodes from the board specific
dts. Since it's not abstracted this way it'll encourage people to just
copy the entire bcm7445.dts for their board.

> diff --git a/arch/arm/boot/dts/bcm7445.dts b/arch/arm/boot/dts/bcm7445.dts
> new file mode 100644
> index 0000000..ffa3305
> --- /dev/null
> +++ b/arch/arm/boot/dts/bcm7445.dts
> @@ -0,0 +1,111 @@
> +/dts-v1/;
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +	model = "Broadcom STB (bcm7445)";
> +	compatible = "brcm,bcm7445", "brcm,brcmstb";
> +	interrupt-parent = <&gic>;
> +
> +	chosen {};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x00 0x00000000 0x00 0x40000000>,
> +		      <0x00 0x40000000 0x00 0x40000000>,
> +		      <0x00 0x80000000 0x00 0x40000000>;
> +	};
> +
> +	cpus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		cpu@0 {
> +			compatible = "brcm,brahma-b15";
> +			device_type = "cpu";
> +			reg = <0>;
> +		};
> +
> +		cpu@1 {
> +			compatible = "brcm,brahma-b15";
> +			device_type = "cpu";
> +			reg = <1>;
> +		};
> +
> +		cpu@2 {
> +			compatible = "brcm,brahma-b15";
> +			device_type = "cpu";
> +			reg = <2>;
> +		};
> +
> +		cpu@3 {
> +			compatible = "brcm,brahma-b15";
> +			device_type = "cpu";
> +			reg = <3>;
> +		};
> +	};
> +
> +	gic: interrupt-controller@ffd00000 {
> +		compatible = "brcm,brahma-b15-gic", "arm,cortex-a15-gic";
> +		reg = <0x00 0xffd01000 0x00 0x1000>,
> +		      <0x00 0xffd02000 0x00 0x2000>,
> +		      <0x00 0xffd04000 0x00 0x2000>,
> +		      <0x00 0xffd06000 0x00 0x2000>;
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +	};
> +
> +	timer {
> +		compatible = "arm,armv7-timer";
> +		interrupts = <1 13 0xf08>,
> +			     <1 14 0xf08>,
> +			     <1 11 0xf08>,
> +			     <1 10 0xf08>;

These should leverage the preprocessor defines that are available
e.g.
		interrupts = <GIC_PPI 13 GIC_CPU_MASK_RAW(15)|IRQ_TYPE_LEVEL_LOW>,
		...

> +	};
> +
> +	rdb {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "simple-bus";
> +		ranges = <0 0x00 0xf0000000 0x1000000>;
> +
> +		serial@406b00 {
> +			compatible = "ns16550a";
> +			reg = <0x406b00 0x20>;
> +			reg-shift = <2>;
> +			reg-io-width = <4>;
> +			interrupts = <0 75 0x4>;

same here:

			interrupt = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>;

-Matt
