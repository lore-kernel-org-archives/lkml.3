Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3FFACa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 20:02:30 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:39817 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3FFAC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 20:02:28 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] mfd: DT bindings for the palmas family MFD
To: J Keerthy <j-keerthy@ti.com>, linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        t-kristo@ti.com, lee.jones@linaro.org, J Keerthy <j-keerthy@ti.com>,
        Ian Lartey <ian@slimlogic.co.uk>
In-Reply-To: <1370335309-6319-1-git-send-email-j-keerthy@ti.com>
References: <1370335309-6319-1-git-send-email-j-keerthy@ti.com>
Date: Thu, 06 Jun 2013 01:02:19 +0100
Message-Id: <20130606000219.6F8BF3E10E4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013 14:11:49 +0530, J Keerthy <j-keerthy@ti.com> wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> Add the various binding files for the palmas family of chips. There is a
> top level MFD binding then a seperate binding for regulators IP blocks on chips.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>

Applied, thanks.

g.

> ---
> Changes from v1:
> * Corrected ti,ldo6_vibrator property ---> ti,ldo6-vibrator
> * Added the irq.h header file inclusion for defining type of interrupt
> 
>  Documentation/devicetree/bindings/mfd/palmas.txt   |   49 +++++++++++++++
>  .../devicetree/bindings/regulator/palmas-pmic.txt  |   65 ++++++++++++++++++++
>  2 files changed, 114 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
>  create mode 100644 Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
> new file mode 100644
> index 0000000..c6c5e78
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
> @@ -0,0 +1,49 @@
> +* palmas device tree bindings
> +
> +The TI palmas family current members :-
> +twl6035 (palmas)
> +twl6037 (palmas)
> +tps65913 (palmas)
> +tps65914 (palmas)
> +
> +Required properties:
> +- compatible : Should be from the list
> +  ti,twl6035
> +  ti,twl6036
> +  ti,twl6037
> +  ti,tps65913
> +  ti,tps65914
> +  ti,tps80036
> +and also the generic series names
> +  ti,palmas
> +- interrupt-controller : palmas has its own internal IRQs
> +- #interrupt-cells : should be set to 2 for IRQ number and flags
> +  The first cell is the IRQ number.
> +  The second cell is the flags, encoded as the trigger masks from
> +  Documentation/devicetree/bindings/interrupts.txt
> +- interrupt-parent : The parent interrupt controller.
> +
> +Optional properties:
> +  ti,mux_padX : set the pad register X (1-2) to the correct muxing for the
> +  		hardware, if not set will use muxing in OTP.
> +
> +Example:
> +
> +palmas {
> +	compatible = "ti,twl6035", "ti,palmas";
> +	reg = <0x48>
> +	interrupt-parent = <&intc>;
> +	interrupt-controller;
> +	#interrupt-cells = <2>;
> +
> +	ti,mux-pad1 = <0>;
> +	ti,mux-pad2 = <0>;
> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	pmic {
> +		compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
> +		....
> +	};
> +}
> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> new file mode 100644
> index 0000000..a0ccdf2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> @@ -0,0 +1,65 @@
> +* palmas regulator IP block devicetree bindings
> +
> +Required properties:
> +- compatible : Should be from the list
> +  ti,twl6035-pmic
> +  ti,twl6036-pmic
> +  ti,twl6037-pmic
> +  ti,tps65913-pmic
> +  ti,tps65914-pmic
> +and also the generic series names
> +  ti,palmas-pmic
> +
> +Optional properties:
> +- ti,ldo6-vibrator : ldo6 is in vibrator mode
> +
> +Optional nodes:
> +- regulators : should contain the constrains and init information for the
> +	       regulators. It should contain a subnode per regulator from the
> +	       list.
> +	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
> +	       smps45, smps457, smps7 depending on varient, smps6, smps[8-10],
> +	       ldo[1-9], ldoln, ldousb
> +
> +	       optional chip specific regulator fields :-
> +	       ti,warm-reset - maintain voltage during warm reset(boolean)
> +	       ti,roof-floor - control voltage selection by pin(boolean)
> +	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 - auto,
> +	       2 - eco, 3 - forced pwm
> +	       ti,tstep - slope control 0 - Jump, 1 10mV/us, 2 5mV/us, 3 2.5mV/us
> +	       ti,smps-range - OTP has the wrong range set for the hardware so override
> +	       0 - low range, 1 - high range
> +
> +Example:
> +
> +#include <include/dt-bindings/interrupt-controller/irq.h>
> +
> +pmic {
> +	compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
> +	interrupt-parent = <&palmas>;
> +	interrupts = <14 IRQ_TYPE_NONE>;
> +	interrupt-name = "short-irq";
> +
> +	ti,ldo6-vibrator;
> +
> +	regulators {
> +		smps12_reg : smps12 {
> +			regulator-name = "smps12";
> +			regulator-min-microvolt = < 600000>;
> +			regulator-max-microvolt = <1500000>;
> +			regulator-always-on;
> +			regulator-boot-on;
> +			ti,warm-reset;
> +			ti,roof-floor;
> +			ti,mode-sleep = <0>;
> +			ti,tstep = <0>;
> +			ti,smps-range = <1>;
> +		};
> +
> +		ldo1_reg: ldo1 {
> +			regulator-name = "ldo1";
> +			regulator-min-microvolt = <2800000>;
> +			regulator-max-microvolt = <2800000>;
> +		};
> +	};
> +};
> -- 
> 1.7.5.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
