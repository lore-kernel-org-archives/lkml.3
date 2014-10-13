Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaJMPAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:00:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59409 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbaJMPAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:00:51 -0400
Date: Mon, 13 Oct 2014 16:00:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v3 2/2] DT: iio: vadc: document dt binding
Message-ID: <20141013150039.GB16598@leverpostej>
References: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com>
 <1411563415-11933-3-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411563415-11933-3-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 01:56:55PM +0100, Stanimir Varbanov wrote:
> Document DT binding for Qualcomm SPMI PMIC voltage ADC
> driver.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  .../devicetree/bindings/iio/adc/qcom,spmi-vadc.txt |  130 ++++++++++++++++++++
>  1 files changed, 130 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
> new file mode 100644
> index 0000000..fa30300
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
> @@ -0,0 +1,130 @@
> +Qualcomm's SPMI PMIC voltage ADC
> +
> +SPMI PMIC voltage ADC (VADC) provides interface to clients to read
> +voltage. A 15 bit ADC is used for voltage measurements. There are multiple
> +peripherals to the VADC and the scope of the driver is to provide interface
> +for the USR peripheral of the VADC.
> +
> +VADC node:
> +
> +- compatible:
> +    Usage: required
> +    Value type: <string>

Technically this is a list of strings.

> +    Definition: Should contain "qcom,spmi-vadc".
> +
> +- reg:
> +    Usage: required
> +    Value type: <u32>

This is an address + size pair, not a u32 (following your example).

> +    Definition: Base address in the SPMI PMIC register map.

And the size, too.

> +
> +- address-cells:
> +    Usage: required
> +    Value type: <u32>
> +    Definition: Must be one.

#address-cells.

What would this cell represent within the ADC?

> +
> +- size-cells:
> +    Usage: required
> +    Value type: <u32>
> +    Definition: Must be zero.

#size-cells.

> +
> +- interrupts:
> +    Usage: optional
> +    Value type: <prop-encoded-array>
> +    Definition: End of conversion interrupt number. If this property does
> +            not exist polling will be used instead.

Just say "end of conversion interrupt". The interrupts property is
standard, and driver behaviour is not a property of the device.

> +
> +- interrupt-names:
> +    Usage: optional
> +    Value type: <string>
> +    Definition: Should contain the interrupt name "eoc" (end of conversion).

If you wish to use interrupt-names, please define interrupts in terms of
interrupt-names so as to make the relationship clear and to avoid
redundancy.

> +
> +Channel node properties:
> +
> +- reg:
> +    Usage: required
> +    Value type: <u32>
> +    Definition: AMUX channel number.
> +            See include/dt-bindings/iio/qcom,spmi-pmic-vadc.h

That header should be part of this patch (and this patch should come
before the driver).

> +
> +- qcom,decimation:
> +    Usage: optional
> +    Value type: <u32>
> +    Definition: Sampling rate to use for the individual channel measurement.
> +            Quicker measurements can be made by reducing decimation ratio.
> +            Valid values are 512, 1024, 2048, 4096.
> +            If property is not found, default value of 512 will be used.

This description does not make sense. If reducing the value increases
the sampling rate, this property should not be described as the
"sampling rate".

This feels like something that should be runtime configurable rather
than a fixed device property.

> +
> +- qcom,pre-scaling:
> +    Usage: optional
> +    Value type: <u32 array>
> +    Definition: Used for scaling the channel input signal before the signal is
> +            fed to VADC. The configuration for this node is to know the
> +            pre-determined ratio and use it for post scaling. Select one from
> +            the following options.
> +            <1 1>, <1 3>, <1 4>, <1 6>, <1 20>, <1 8>, <10 81>, <1 10>
> +            If property is not found default value depending of chip will be used.
> +
> +- qcom,ratiometric:
> +    Usage: optional
> +    Value type: <empty>
> +    Definition: Channel calibration type. If this property is specified
> +            VADC will use the VDD reference(1.8V) and GND for channel
> +            calibration. If property is not found, channel will be
> +            calibrated with 625mV and 1.25V reference channels.
> +            Otherwise the absolute calibration will be used.

Surely this should be part of the specifier?

> +
> +- qcom,hw-settle-time:
> +    Usage: optional
> +    Value type: <u32>
> +    Definition: Time between AMUX getting configured and the ADC starting
> +            conversion. Delay = 100us * (value) for value < 11, and
> +            2ms * (value - 10) otherwise.
> +            Valid values are: 0, 100, 200, 300, 400, 500, 600, 700, 800,
> +            900 us and 1, 2, 4, 6, 8, 10 ms
> +            If property is not found, channel will use 0us.
> +
> +- qcom,avg-samples:
> +    Usage: optional
> +    Value type: <u32>
> +    Definition: Number of samples to be used for measurement.
> +            Fast averaging provides the option to obtain a single measurement
> +            from the ADC that is an average of multiple samples. The value
> +            selected is 2^(value).
> +            Valid values are: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512
> +            If property is not found, 1 sample will be used.

Likewise.

thanks,
Mark.

> +
> +NOTE: At least reference channel nodes are required. The reference channels
> +      might be different depending on PMIC version.
> +      Reference channels per type of calibration are:
> +       - absolute
> +         (VADC_REF_625MV or VADC_SPARE1) and VADC_REF_1250MV
> +       - ratiomatric
> +         VADC_GND_REF and VADC_VDD_VADC
> +
> +Example:
> +	/* VADC node */
> +	pmic_vadc: vadc@3100 {
> +		compatible = "qcom,spmi-vadc";
> +		reg = <0x3100 0x100>;
> +		interrupts = <0x0 0x31 0x0 IRQ_TYPE_EDGE_RISING>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		#io-channel-cells = <1>;
> +		io-channel-ranges;
> +
> +		/* Channel node */
> +		usb_id_nopull {
> +			reg = <VADC_LR_MUX10_USB_ID>;
> +			qcom,decimation = <512>;
> +			qcom,ratiometric;
> +			qcom,hw-settle-time = <200>;
> +			qcom,avg-samples = <1>;
> +			qcom,pre-scaling = <1 3>;
> +		};
> +	};
> +
> +	/* IIO client node */
> +	usb {
> +		io-channels = <&pmic_vadc VADC_LR_MUX10_USB_ID>;
> +		io-channel-names = "vadc";
> +	};
> -- 
> 1.7.0.4
> 
> 
