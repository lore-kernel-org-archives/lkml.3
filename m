Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab3HTJMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:12:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59475 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747Ab3HTJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:12:43 -0400
Date: Tue, 20 Aug 2013 10:12:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
Message-ID: <20130820091228.GW3719@e106331-lin.cambridge.arm.com>
References: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com>
Thread-Topic: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleksandr,

[Adding Jonathan Cameron and Guenter Roeck to Cc]

Apologies for the delay replying to this. In attempting to verify this
made sense I went and read the IIO bindings documentation, and I'm
somewhat confused by the model.

As far as I can see, the only consumer of IIO channels is the
"iio-hwmon" binding, which seems to be a binding for Linux-specific
infrastructure rather than any actual device. This runs counter to the
way DT is supposed to function (describing the hardware rather than how
it's used). As far as I can see, this linkage is described because only
a subset of the ADCs on the device are actually wired to something?

I also see a couple of IIO bindings ("adi,adf435x*, and "adi,ad7303")
which don't describe any iio channel cells at all, so I'm somewhat
confused by what the IIO channels actually represent, and why they must
be consumed elsewhere. As far as I can see, an IIO channel represents a
single ADC's registers in an IIO device, so I'm not sure why this must
be exported via the channel concept -- it's not physically wired.

Have I misunderstood something here?

Thanks,
Mark.

On Mon, Aug 19, 2013 at 12:29:25PM +0100, Oleksandr Kozaruk wrote:
> Add required documentation for twl6030 GPADC device tree
> bindings.
> 
> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
> ---
>  .../devicetree/bindings/iio/adc/twl6030-gpadc.txt  | 45 ++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
> new file mode 100644
> index 0000000..6cd3ef3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
> @@ -0,0 +1,45 @@
> +Texas Instruments twl6030/twl6032 GPADC device driver
> +
> +Required properties:
> +	- compatible: must be "ti,twl6030-gpadc" for TWL6030 or
> +	  "ti,twl6032-gpadc" for TWL6032
> +	- interrupts: interrupt number associated with it
> +	- #io-channel-cells: must be <1> - multiple IIO outputs are present
> +	  iio consumers can use following io-channels:
> +		twl6030:
> +			0 - battery type
> +			1 - battery temperature resistor value
> +			2 - audio accessory/general purpose
> +			3 - general purpose
> +			4 - temperature/general purpose
> +			5 - general purpose
> +			6 - general purpose
> +			7 - main battery
> +			8 - backup battery
> +			9 - charger input
> +			10 - VBUS
> +			11 - VBUS charging current
> +			14 - USB ID
> +		twl6032:
> +			0 - battery type
> +			1 - battery temperature resistor value
> +			2 - audio accessory/general purpose
> +			3 - temperature with external diode/general purpose
> +			4 - temperature/general purpose
> +			5 - general purpose
> +			6 - general purpose
> +			7 - system supply
> +			8 - backup battery
> +			9 - charger input
> +			10 - VBUS
> +			11 - VBUS charging current
> +			14 - USB ID
> +			17 - battery charging current
> +			18 - battery voltage
> +
> +Example:
> +	adc {
> +		compatible = "ti,twl6030-gpadc";
> +		interrupts = <3>;
> +		#io-channel-cells = <1>;
> +	};
> -- 
> 1.8.1.2
> 
> 
