Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaJCM1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:27:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63597 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbaJCM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:27:42 -0400
Date: Fri, 3 Oct 2014 13:27:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "atull@opensource.altera.com" <atull@opensource.altera.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Cc: "linux@roeck-us.net" <linux@roeck-us.net>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
Message-ID: <20141003122736.GH26643@leverpostej>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
 <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 07:37:48PM +0100, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add device tree bindings documentation for ltc2978.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
> v2: clean whitespace
> ---
>  .../devicetree/bindings/hwmon/ltc2978.txt          |   41 ++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> new file mode 100644
> index 0000000..b2d9c4d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> @@ -0,0 +1,41 @@
> +ltc2978
> +
> +Required properties:
> + - compatible: one of: ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676

Could we please format this like:

- compatible: should contain one of:
  * "ltc2974"
  * "ltc2977"
  * "ltc2978"
  * "ltc3880"
  * "ltc3883"
  * "ltm4676"

Given the file name, are these all variants of ltc2978? 

> + - reg: I2C address
> +
> +Optional properties:
> + Name of the optional regulator subnode must be "regulators".
> +  - #address-cells must be 1.

What's the single address cell used for?

> +  - #size-cells must be 0.
> +
> + For each regulator:
> +  - reg: regulator number

Which can be...?

What does this correspond to in the HW?

> +  - regulator-compatible: must be vout_en<regulator number> such as vout_en3
> +    valid range is:
> +      ltc2977, ltc2978 : vout_en0 - vout_en7
> +      ltc2974          : vout_en0 - vout_en3
> +      ltc3880, ltm4676 : vout_en0 - vout_en1
> +      ltc3883          : vout_en0 only

In other bindings I believe I've seen the node name used for this.

Mark, what's the preferred scheme for identifying regulators in a
container node?

> +  - regulator-name: arbitrary name for regulator

Drop the 'aribtarary'. Either this should be the name of the regulator
on the board, or it shouldn't be necessary.

Mark.

> +
> +Example:
> +ltc2978@5e {
> +	compatible = "ltc2978";
> +	reg = <0x5e>;
> +	regulators {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		vdacp0_reg: regulator@0 {
> +			reg = <0>;
> +			regulator-compatible = "vout_en0";
> +			regulator-name = "FPGA-2.5V";
> +		};
> +		vdacp2_reg: regulator@2 {
> +			reg = <2>;
> +			regulator-compatible = "vout_en2";
> +			regulator-name = "FPGA-1.5V";
> +		};
> +	};
> +};
> -- 
> 1.7.9.5
> 
> 
