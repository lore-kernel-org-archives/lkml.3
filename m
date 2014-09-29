Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaI2LJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:09:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64834 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbaI2LJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:09:34 -0400
Date: Mon, 29 Sep 2014 12:09:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] DT: add binding for mxs regulator
Message-ID: <20140929110919.GB2432@leverpostej>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
 <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com>
Thread-Topic: [PATCH 1/2] DT: add binding for mxs regulator
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 01:59:47AM +0100, Stefan Wahren wrote:
> This patch adds the Device tree bindings for the Freescale MXS
> on-chip regulators.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  .../bindings/regulator/mxs-regulator.txt           |   36 ++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/mxs-regulator.txt b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> new file mode 100644
> index 0000000..e3133a4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> @@ -0,0 +1,36 @@
> +MXS regulators
> +
> +Required node properties:
> +- compatible: Should be "simple-bus"

This does not look like an appropriate use of simple-bus.

Why do you want the parent node to be a simple-bus?

> +- #address-cells: Number of cells required to define regulator register,
> +  must be 1
> +- #size-cells: Number of cells required to define register size, must be 1

Why must this be the case, given that the child node expects an absolute
physical address?

What's wrong with #address-cells = <2>, for example?

> +- reg: Absolute physical address and size of the register set for the device

Why is this here _and_ in the child node(s)?

What is the difference between this node and its children?

Can there be more than one sub-node?

Mark.

> +
> +Required regulator properties:
> +- compatible: Must be "fsl,mxs-regulator"
> +- reg: Absolute physical address of the register set for the regulator
> +
> +Any regulator property defined as part of the core regulator
> +binding, defined in regulator.txt, can also be used.
> +
> +Example:
> +
> +	power: power@80044000 {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		reg = <0x80044000 0x2000>;
> +		ranges;
> +
> +		reg_vddd: regulator@80044040 {
> +			reg = <0x80044040 0x10>;
> +			compatible = "fsl,mxs-regulator";
> +			regulator-name = "vddd";
> +			regulator-min-microvolt = <800000>;
> +			regulator-max-microvolt = <1575000>;
> +			regulator-boot-on;
> +			vddd-supply = <&reg_vdda>;
> +		};
> +	};
> +
> -- 
> 1.7.9.5
> 
> 
