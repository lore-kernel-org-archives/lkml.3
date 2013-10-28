Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3J1K7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:59:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46579 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3J1K7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:59:45 -0400
Subject: Re: [RFC][PATCHv5 4/4] Documentation: Add device tree bindings for Freescale FTM PWM.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1382951151-31517-1-git-send-email-Li.Xiubo@freescale.com>
Date: Mon, 28 Oct 2013 05:59:41 -0500
Cc: <r65073@freescale.com>, <thierry.reding@gmail.com>,
        <grant.likely@linaro.org>, <ian.campbell@citrix.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <matt.porter@linaro.org>,
        <s.hauer@pengutronix.de>, <swarren@wwwdotorg.org>,
        <t.figa@samsung.com>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <224C2E26-6C33-4DBB-BC06-A4BA470FDA39@codeaurora.org>
References: <1382951151-31517-1-git-send-email-Li.Xiubo@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2013, at 4:05 AM, Xiubo Li wrote:

> The RFC patch only added "See ../clock/clock-bindings.txt for details of
> the property values."
> 
> 
> 
> This adds the Document for Freescale FTM PWM driver under
> Documentation/devicetree/bindings/pwm/.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 34 ++++++++++++++++++++++
> 1 file changed, 34 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> 
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> new file mode 100644
> index 0000000..175b762
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> @@ -0,0 +1,34 @@
> +Freescale FTM PWM controller

What does FTM stand for, and can we spell out PWM at least once early on.

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
> +- clocks : Must contain a clock specifier for each entry in clock-names,
> +  See ../clock/clock-bindings.txt for details of the property values.
> +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one of the
> +  entries in clock-names.

Why do we need this, why not just have only the clock-names/clocks reference the clk that is actually used?

> +- pinctrl-names: must contain a "default" entry.
> +- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
> +  See ../pinctrl/pinctrl-bindings.txt for details of the property values.

let's drop the .. when making directory references.

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
> 1.8.4

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

