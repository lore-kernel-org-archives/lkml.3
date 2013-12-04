Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3LDJjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:39:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40250 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800Ab3LDJjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:39:16 -0500
Date: Wed, 4 Dec 2013 09:39:11 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alex Elder <alex.elder@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] clk: bcm281xx: define kona clock binding
Message-ID: <20131204093911.GE16025@e106331-lin.cambridge.arm.com>
References: <529EA78E.7060904@linaro.org>
 <529EA80A.60801@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529EA80A.60801@linaro.org>
Thread-Topic: [PATCH 1/3] clk: bcm281xx: define kona clock binding
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:56:58AM +0000, Alex Elder wrote:
> Document the device tree binding for Broadcom Kona architecture
> clock control units and clocks.  Kona device nodes are represented
> with compatible strings having "bcm11351" in their name.
> 
> Kona clocks are managed by "clock control units" (CCUs).  Each CCU
> has a device tree node, and within that node are defined the names
> of the clocks provided by the CCU.
> 
> The BCM281xx family of SoCs use Kona CCUs and clocks.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>  .../devicetree/bindings/clock/bcm-kona-clock.txt   |   95
> ++++++++++++++++++++
>  1 file changed, 95 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
> b/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
> new file mode 100644
> index 0000000..0cafd6a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
> @@ -0,0 +1,95 @@
> +Broadcom Kona Family Clocks
> +
> +This binding is associated with Broadcom SoCs having "Kona" style
> +clock control units (CCUs).  A CCU is a clock provider that manages
> +a set of clock signals.  Each CCU is represented by a node in the
> +device tree.
> +
> +This binding uses the common clock binding:
> +    Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Many source clocks are described using the "fixed-clock" binding:
> +    Documentation/devicetree/bindings/clock/fixed-clock.txt

Is this necessary? While this describes the device it doesn't describe
this binding.

> +
> +Required properties:
> +- compatible
> +	Shall have a value "brcm,bcm11351-<which>-ccu", where
> +	<which> identifies the particular CCU (see below).

It would be nice to have a full list here, as that makes finding the
file easier. Something like:

- compatible: should contain one of:
   * "brcm,bcm11351-root-ccu"
   * "brcm,bcm11351-aon-ccu"
   * "brcm,bcm11351-hub-ccu"
   * "brcm,bcm11351-master-ccu"
  The differences between these are described in greater detail below.

> +- reg
> +	Shall define the base and range of the address space
> +	containing clock control registers
> +- #clock-cells
> +	Shall have the value <1>

How about:

- #clock-cells: Should be <1>. The permitted clock-specifier values are
  defined below.

> +- clock-output-names
> +	Shall be an ordered list of strings defining the names of
> +	the clocks provided by the CCU.
> +
> +Clock consumers refer to a particular clock supplied by a CCU using
> +a phandle and specifier pair, using the phandle for the CCU device
> +tree node and the clock's symbolic specifier.  The clock specifier
> +is a CCU-unique 0-based index value.

This is redundant given the common clock binding and the description of
#clock-cells above.

> +
> +
> +BCM281XX family SoCs use Kona CCUs.  The following table defines
> +the set of CCUs and clock specifiers for BCM281XX clocks.  The
> +compatible string for the CCU uses the name in the "CCU" column
> +below as it's <which> value.
> +
> +    CCU     Clock           Type    Index   Specifier
> +    ---     -----           ----    -----   ---------
> +    root    frac_1m         peri      0     BCM281XX_ROOT_CCU_FRAC_1M
> +
> +    aon     hub_timer       peri      0     BCM281XX_AON_CCU_HUB_TIMER
> +    aon     pmu_bsc         peri      1     BCM281XX_AON_CCU_PMU_BSC
> +    aon     pmu_bsc_var     peri      2     BCM281XX_AON_CCU_PMU_BSC_VAR
> +
> +    hub     tmon_1m         peri      0     BCM281XX_HUB_CCU_TMON_1M
> +
> +    master  sdio1           peri      0     BCM281XX_MASTER_CCU_SDIO1
> +    master  sdio2           peri      1     BCM281XX_MASTER_CCU_SDIO2
> +    master  sdio3           peri      2     BCM281XX_MASTER_CCU_SDIO3
> +    master  sdio4           peri      3     BCM281XX_MASTER_CCU_SDIO4
> +    master  dmac            peri      4     BCM281XX_MASTER_CCU_DMAC
> +    master  usb_ic          peri      5     BCM281XX_MASTER_CCU_USB_IC
> +    master  hsic2_48m       peri      6     BCM281XX_MASTER_CCU_HSIC_48M
> +    master  hsic2_12m       peri      7     BCM281XX_MASTER_CCU_HSIC_12M
> +
> +    slave   uartb           peri      0     BCM281XX_SLAVE_CCU_UARTB
> +    slave   uartb2          peri      1     BCM281XX_SLAVE_CCU_UARTB2
> +    slave   uartb3          peri      2     BCM281XX_SLAVE_CCU_UARTB3
> +    slave   uartb4          peri      3     BCM281XX_SLAVE_CCU_UARTB4
> +    slave   ssp0            peri      4     BCM281XX_SLAVE_CCU_SSP0
> +    slave   ssp2            peri      5     BCM281XX_SLAVE_CCU_SSP2
> +    slave   bsc1            peri      6     BCM281XX_SLAVE_CCU_BSC1
> +    slave   bsc2            peri      7     BCM281XX_SLAVE_CCU_BSC2
> +    slave   bsc3            peri      8     BCM281XX_SLAVE_CCU_BSC3
> +    slave   pwm             peri      9     BCM281XX_SLAVE_CCU_PWM

I guess the Specifier column is referring to some defines in a header
file? It would be good to mention which header file these are in.

The Index is also a specifier, it just happens to not be symbolic.

> +
> +
> +Device tree example:
> +
> +	clocks {
> +		slave_ccu: slave_ccu {
> +			compatible = "brcm,bcm11351-slave-ccu";
> +			reg = <0x3e011000 0x0f00>;
> +			#clock-cells = <1>;
> +			clock-output-names = "uartb",
> +					     "uartb2",
> +					     "uartb3",
> +					     "uartb4";
> +		};
> +		ref_crystal_clk: ref_crystal {
> +			#clock-cells = <0>;
> +			compatible = "fixed-clock";
> +			clock-frequency = <26000000>;
> +		};
> +	};

This is wrong, as the clocks container node us not defined as any type
of bus, and does not have the requisite #address-cells and #size-cells.
Really this should _not_ be probed, as the kernel does not know anything
about the clocks node. It could be some non-MMIO bus that it doesn't
understand, or one which requires other clocks.

I think the current way that we probe clocks is somewhat broken in this
regard.

There's no reason to put the clocks in this container at all; just put
them under the root. If you really want to use a container, please at
least use a simple-bus with the requisite #address-cells, #size-cells,
and ranges properties.

Thanks,
Mark.
