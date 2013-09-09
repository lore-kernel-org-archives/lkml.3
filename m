Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3IIKwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:52:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49199 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab3IIKwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:52:30 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522DA86B.6000603@roeck-us.net>
Date: Mon, 09 Sep 2013 03:52:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, broonie@kernel.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for
 LM90
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-3-git-send-email-wni@nvidia.com>
In-Reply-To: <1378722552-10357-3-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 03:29 AM, Wei Ni wrote:
> Add OF document for LM90 in Documentation/devicetree/.
>
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>   Documentation/devicetree/bindings/hwmon/lm90.txt |   44 ++++++++++++++++++++++
>   1 file changed, 44 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/hwmon/lm90.txt
>
> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt
> new file mode 100644
> index 0000000..5570875
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/lm90.txt
> @@ -0,0 +1,44 @@
> +* LM90 series thermometer.
> +
> +Required node properties:
> +- compatible: manufacture and chip name, one of

manufacturer

> +		"<manufacture>,adm1032"
> +		"<manufacture>,adt7461"
> +		"<manufacture>,adt7461a"
> +		"<manufacture>,g781"
> +		"<manufacture>,lm90"
> +		"<manufacture>,lm86"
> +		"<manufacture>,lm89"
> +		"<manufacture>,lm99"
> +		"<manufacture>,max6646"
> +		"<manufacture>,max6647"
> +		"<manufacture>,max6649"
> +		"<manufacture>,max6657"
> +		"<manufacture>,max6658"
> +		"<manufacture>,max6659"
> +		"<manufacture>,max6680"
> +		"<manufacture>,max6681"
> +		"<manufacture>,max6695"
> +		"<manufacture>,max6696"
> +		"<manufacture>,nct1008"
> +		"<manufacture>,w83l771"
> +		"<manufacture>,sa56004"
> +
Shouldn't the manufacturers be listed explicitly ?

> +- reg: I2C bus address of the device
> +
> +Optional properties:
> +- vcc-supply: vcc regulator for the supply voltage.
> +              If this is not set, assuming vdd is always powered.

s/assuming/assume/

> +- interrupts: Contains a single interrupt specifier which describes the
> +              LM90 pin6 output.
> +              See interrupt-controller/interrupts.txt for the format.
> +
> +Example LM90 node:
> +
> +temp-sensor {
> +	compatible = "onnn,nct1008";
> +	reg = <0x4c>;
> +	vcc-supply = <&palmas_ldo6_reg>;
> +	interrupt-parent = <&gpio>;

List above as optional property.

> +	interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
> +}
>

