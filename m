Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaIISAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:00:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47878 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbaIISAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:00:19 -0400
Date: Tue, 9 Sep 2014 18:59:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan Wahren <info@lategoodbye.de>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 1/3] DT: add binding for MXS regulator
Message-ID: <20140909175940.GF3896@leverpostej>
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
 <1410089869-6611-2-git-send-email-info@lategoodbye.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410089869-6611-2-git-send-email-info@lategoodbye.de>
Thread-Topic: [PATCH RFC 1/3] DT: add binding for MXS regulator
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2014 at 12:37:47PM +0100, Stefan Wahren wrote:
> This patch adds the Device tree bindings for the Freescale MXS on-chip
> regulators.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  .../bindings/regulator/mxs-regulator.txt           | 38 ++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/mxs-regulator.txt b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> new file mode 100644
> index 0000000..c3226cc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> @@ -0,0 +1,38 @@
> +MXS regulators
> +
> +Required node properties:
> +- compatible: Should be "fsl,<soc>-power", where soc is "imx23" or "imx28"
> +- reg: Offset and length of the register set for the device

We require #address-cells and #size-cells if the child nodes have reg
entries.

> +
> +Required regulator properties:
> +- compatible: Must be "fsl,mxs-regulator"
> +- reg: Offset of the register set for the regulator

Is this the offset or the absolute physical address?

The example seems to be absolute.

> +- mxs-max-reg-val: Maximum value of this register

What does this even mean? What's the format?

Is this not implied by standard properties like regulator-max-microvolt?

> +Optional regulator properties:
> +- mxs-default-microvolt: initial voltage of the regulator

Why is this necessary?

Mark.

> +
> +Any regulator property defined as part of the core regulator
> +binding, defined in regulator.txt, can also be used.
> +
> +Example:
> +
> +	power: power@80044000 {
> +		compatible = "fsl,imx28-power";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		reg = <0x80044000 0x2000>;
> +
> +		reg_vddio: regulator-vddio@80044060 {
> +			reg = <0x80044060>;
> +			compatible = "fsl,mxs-regulator";
> +			regulator-name = "vddio";
> +			regulator-min-microvolt = <2800000>;
> +			regulator-max-microvolt = <3600000>;
> +			regulator-microvolt-offset = <80000>;
> +			regulator-always-on;
> +			mxs-max-reg-val = <0x10>;
> +			mxs-default-microvolt = <3300000>;
> +		};
> +	};
> +
> -- 
> 1.8.1.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
