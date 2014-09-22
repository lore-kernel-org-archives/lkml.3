Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaIVLD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:03:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57275 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbaIVLDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:03:22 -0400
Date: Mon, 22 Sep 2014 12:03:20 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Marek Belisko <marek@goldelico.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "hns@goldelico.com" <hns@goldelico.com>,
        "sre@debian.org" <sre@debian.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Documentation: DT: Document twl4030-madc-battery
 bindings.
Message-ID: <20140922110320.GI3290@leverpostej>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
 <1394052739-8589-4-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394052739-8589-4-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 05, 2014 at 08:52:19PM +0000, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  .../bindings/power_supply/twl4030_madc_battery.txt | 43 ++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> 
> diff --git a/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> new file mode 100644
> index 0000000..fd0b6d2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
> @@ -0,0 +1,43 @@
> +twl4030_madc_battery
> +
> +Required properties:
> + - compatible : "ti,twl4030-madc-battery"

I'm rather confused by this; the code seems to have stripped away all
the twl4030 dependencies and this now seems to be a generic ADC battery
status driver. So why does this need to be specific to twl4030?

> + - capacity : battery capacity in uAh

I would make the units explicit in the name; "capacity" can be measured
in many ways.

> + - charging-calibration-data : list of voltage(mV):level(%) values
> +	for charging calibration (see example)
> + - discharging-calibration-data : list of voltage(mV):level(%) values
> +	for discharging calibration (see example)

Regardless of the prefixing of these property names, the specifics are
unclear to me.

Does this apply to vbat?

Is vbat guaranteed to read in mV?

Is any particular order required? The example seems to go be in
descending percentage values.

Is any particular interpolation expected on behalf of the OS, or is this
just an informative set of measurements that hte OS can use as it sees
fit?

> + - io-channels: Should contain IIO channel specifiers
> +	for each element in io-channel-names.
> +- io-channel-names: Should contain the following values:
> + * "temp" - The ADC channel for temperature reading

Which units? Where is this used?

> + * "ichg" - The ADC channel for battery charging status

How exactly is this used to detect the charging status?

> + * "vbat" - The ADC channel to measure the battery voltage
> +
> +Example:
> +	madc-battery {
> +		compatible = "ti,twl4030-madc-battery";
> +		capacity = <1200000>;
> +		charging-calibration-data = <4200 100
> +					     4100 75
> +					     4000 55
> +					     3900 25
> +					     3800 5
> +					     3700 2
> +					     3600 1
> +					     3300 0>;

Please bracket list entries individually (as you've done with
io-channels).

Thanks,
Mark.

> +
> +		discharging-calibration-data = <4200 100
> +						4100 95
> +						4000 70
> +						3800 50
> +						3700 10
> +						3600 5
> +						3300 0>;
> +		io-channels = <&twl_madc 1>,
> +	                      <&twl_madc 10>,
> +			      <&twl_madc 12>;
> +		io-channel-names = "temp",
> +		                   "ichg",
> +		                   "vbat";
> +	};
> -- 
> 1.8.3.2
> 
> 
