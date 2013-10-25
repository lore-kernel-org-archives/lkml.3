Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3JYWvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:51:21 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:43530 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3JYWvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:51:12 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCHv5 4/4] Documentation: Add device tree bindings for Freescale FTM PWM.
To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
        thierry.reding@gmail.com
Cc: s.hauer@pengutronix.de, swarren@wwwdotorg.org, t.figa@samsung.com,
        linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
In-Reply-To: <1380521611-2764-5-git-send-email-Li.Xiubo@freescale.com>
References: <1380521611-2764-1-git-send-email-Li.Xiubo@freescale.com> <1380521611-2764-5-git-send-email-Li.Xiubo@freescale.com>
Date: Fri, 25 Oct 2013 21:12:11 +0100
Message-Id: <20131025201211.7936EC405D3@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Sep 2013 14:13:31 +0800, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> This adds the Document for Freescale FTM PWM driver under
> Documentation/devicetree/bindings/pwm/.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 33 ++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> 
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> new file mode 100644
> index 0000000..2c6969a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> @@ -0,0 +1,33 @@
> +Freescale FTM PWM controller
> +
> +Required properties:
> +- compatible: Should be "fsl,vf610-ftm-pwm"
> +- reg: Physical base address and length of the controller's registers
> +- #pwm-cells: Should be 3. See pwm.txt in this directory for a description of
> +  the cells format.
> +- clock-names : Includes the following module clock source entries:
> +    "ftm0" (system clock),
> +    "ftm0_fix_sel" (fixed frequency clock),
> +    "ftm0_ext_sel" (external clock)
> +- clocks : Must contain a clock specifier for each entry in clock-names.
> +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one of the
> +  entries in clock-names.
> +- pinctrl-names: must contain a "default" entry.
> +- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
> +  See ../pinctrl/pinctrl-bindings.txt for details of the property values.

Looks okay to me.

g.

> +
> +
> +Example:
> +
> +pwm0: pwm@40038000 {
> +		compatible = "fsl,vf610-ftm-pwm";
> +		reg = <0x40038000 0x1000>;
> +		#pwm-cells = <3>;
> +		clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
> +		clocks = <&clks VF610_CLK_FTM0>,
> +			<&clks VF610_CLK_FTM0_FIX_SEL>,
> +			<&clks VF610_CLK_FTM0_EXT_SEL>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_pwm0_1>;
> +		fsl,pwm-counter-clk = "ftm0_ext_sel";
> +};
> -- 
> 1.8.0
> 
> 

