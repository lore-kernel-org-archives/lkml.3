Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaIMRcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 13:32:21 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48422 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaIMRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 13:32:19 -0400
Message-ID: <54147F9F.3070804@kernel.org>
Date: Sat, 13 Sep 2014 18:32:15 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Stanimir Varbanov <svarbanov@mm-sol.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
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
Subject: Re: [PATCH v2 2/2] DT: iio: vadc: document dt binding
References: <1410448403-19402-1-git-send-email-svarbanov@mm-sol.com> <1410448403-19402-3-git-send-email-svarbanov@mm-sol.com> <5413832F.6040503@gmx.de>
In-Reply-To: <5413832F.6040503@gmx.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/14 00:35, Hartmut Knaack wrote:
> Stanimir Varbanov schrieb, Am 11.09.2014 17:13:
>> Document DT binding for Qualcomm SPMI PMIC voltage ADC
>> driver.
>>
> Still one typo left.
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>> ---
>>  .../devicetree/bindings/iio/adc/qcom,spmi-vadc.txt |  123 ++++++++++++++++++++
>>  1 files changed, 123 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
>> new file mode 100644
>> index 0000000..5abb491
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
>> @@ -0,0 +1,123 @@
>> +Qualcomm's SPMI PMIC voltage ADC
>> +
>> +SPMI PMIC voltage ADC (VADC) provides interface to clients to read
>> +voltage. A 15 bit ADC is used for voltage measurements. There are multiple
>> +peripherals to the VADC and the scope of the driver is to provide interface
>> +for the USR peripheral of the VADC.
>> +
>> +VADC node:
>> +
>> +- compatible:
>> +    Usage: required
>> +    Value type: <string>
>> +    Definition: Should contain "qcom,spmi-vadc".
>> +
>> +- reg:
>> +    Usage: required
>> +    Value type: <u32>
>> +    Definition: Base address in the SPMI PMIC register map.
>> +
>> +- address-cells:
>> +    Usage: required
>> +    Value type: <u32>
>> +    Definition: Must be one.
>> +
>> +- size-cells:
>> +    Usage: required
>> +    Value type: <u32>
>> +    Definition: Must be zero.
>> +
>> +- interrupts:
>> +    Usage: required
>> +    Value type: <prop-encoded-array>
>> +    Definition: End of convertion interrupt number.
> Typo: conversion
>> +
>> +- qcom,poll-eoc:
>> +    Usage: optional
>> +    Value type: <empty>
>> +    Definition: Use polling instead of interrupt for end of conversion
>> +            completion.
>> +
>> +Channel node properties:
>> +
>> +- reg:
>> +    Usage: required
>> +    Value type: <u32>
>> +    Definition: AMUX channel number.
>> +            See include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
>> +
>> +- qcom,decimation:
>> +    Usage: optional
>> +    Value type: <u32>
>> +    Definition: Sampling rate to use for the individual channel measurement.
>> +            Quicker measurements can be made by reducing decimation ratio.
>> +            Valid values are 512, 1024, 2048, 4096.
>> +            If property is not found, default value of 512 will be used.
>> +
>> +- qcom,pre-scaling:
>> +    Usage: optional
>> +    Value type: <u32 array>
>> +    Definition: Used for scaling the channel input signal before the signal is
>> +            fed to VADC. The configuration for this node is to know the
>> +            pre-determined ratio and use it for post scaling. Select one from
>> +            the following options.
>> +            <1 1>, <1 3>, <1 4>, <1 6>, <1 20>, <1 8>, <10 81>, <1 10>
>> +            If property is not found default value depending of chip will be used.
>> +
>> +- qcom,ratiometric:
>> +    Usage: optional
>> +    Value type: <empty>
>> +    Definition: Channel calibration type. If this property is specified
>> +            VADC will use the VDD reference(1.8V) and GND for channel
>> +            calibration. If property is not found, channel will be
>> +            calibrated with 625mV and 1.25V reference channels.
>> +
>> +- qcom,hw-settle-time:
>> +    Usage: optional
>> +    Value type: <u32>
>> +    Definition: Time between AMUX getting configured and the ADC starting
>> +            conversion. Delay = 100us * (value) for value < 11, and
>> +            2ms * (value - 10) otherwise.
>> +            Valid values are: 0, 100, 200, 300, 400, 500, 600, 700, 800,
>> +            900 us and 1, 2, 4, 6, 8, 10 ms
>> +            If property is not found, channel will use 0us.
>> +
>> +- qcom,avg-samples:
>> +    Usage: optional
>> +    Value type: <u32>
>> +    Definition: Number of samples to be used for measurement.
>> +            Fast averaging provides the option to obtain a single measurement
>> +            from the ADC that is an average of multiple samples. The value
>> +            selected is 2^(value).
>> +            Valid values are: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512
>> +            If property is not found, 1 sample will be used.
>> +
>> +NOTE: At least one channel node is required.

Why?  As far as I can see it will register all the channels anyway.  If that is not the intent
you need to build the iio_chan_spec array rather than using a static one.

I'm fine with it providing channels with sensible defaults if they aren't overridden, but then
it should work fine with no channel nodes.

Jonathan


>> +
>> +Example:
>> +	/* VADC node */
>> +	pmic_vadc: vadc@3100 {
>> +		compatible = "qcom,spmi-vadc";
>> +		reg = <0x3100 0x100>;
>> +		interrupts = <0x0 0x31 0x0 IRQ_TYPE_EDGE_RISING>;
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		#io-channel-cells = <1>;
>> +		io-channel-ranges;
>> +
>> +		/* Channel node */
>> +		usb_id_nopull {
>> +			reg = <VADC_LR_MUX10_USB_ID>;
>> +			qcom,decimation = <512>;
>> +			qcom,ratiometric;
>> +			qcom,hw-settle-time = <200>;
>> +			qcom,avg-samples = <1>;
>> +			qcom,pre-scaling = <1 3>;
>> +		};
>> +	};
>> +
>> +	/* IIO client node */
>> +	usb {
>> +		io-channels = <&pmic_vadc VADC_LR_MUX10_USB_ID>;
>> +		io-channel-names = "vadc";
>> +	};
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
