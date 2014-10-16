Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaJPTqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:46:15 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:64527 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaJPTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:46:13 -0400
Date: Thu, 16 Oct 2014 12:46:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull@opensource.altera.com
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v6 1/4] hwmon: ltc2978: device tree bindings documentation
Message-ID: <20141016194607.GA23042@roeck-us.net>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
 <1413399310-19277-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413399310-19277-2-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 01:55:07PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Add device tree bindings documentation for ltc2978.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> ---
> v2: clean whitespace
> 
> v3: list compatible strings in single column
>     add vendor as lltc
>     mention regulators.txt instead of documenting regulator-name
>     s/vout_en/vout/
>     remove size_cells, address-cells
>     use node name to identify regulators
> ---
>  .../devicetree/bindings/hwmon/ltc2978.txt          |   39 ++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> new file mode 100644
> index 0000000..16c1227
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> @@ -0,0 +1,39 @@
> +ltc2978
> +
> +Required properties:
> +- compatible: should contain one of:
> +  * "lltc,ltc2974"
> +  * "lltc,ltc2977"
> +  * "lltc,ltc2978"
> +  * "lltc,ltc3880"
> +  * "lltc,ltc3883"
> +  * "lltc,ltm4676"
> +- reg: I2C slave address
> +
> +Optional properties:
> +- regulators: A node that houses a sub-node for each regulator controlled by
> +  the device. Each sub-node is identified using the node's name, with valid
> +  values listed below. The content of each sub-node is defined by the
> +  standard binding for regulators; see regulator.txt.
> +
> +Valid names of regulators depend on number of supplies supported per device:
> +  * ltc2974 : vout0 - vout3
> +  * ltc2977 : vout0 - vout7
> +  * ltc2978 : vout0 - vout7
> +  * ltc3880 : vout0 - vout1
> +  * ltc3883 : vout0
> +  * ltm4676 : vout0 - vout1
> +
> +Example:
> +ltc2978@5e {
> +	compatible = "ltc2978";

Nitpick, but still:

		"lltc,ltc2978"

> +	reg = <0x5e>;
> +	regulators {
> +		vout0 {
> +			regulator-name = "FPGA-2.5V";
> +		};
> +		vout2 {
> +			regulator-name = "FPGA-1.5V";
> +		};
> +	};
> +};
> -- 
> 1.7.9.5
> 
