Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaJNF21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 01:28:27 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35451 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaJNF2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 01:28:24 -0400
Message-ID: <543CB46F.2040803@mm-sol.com>
Date: Tue, 14 Oct 2014 08:28:15 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v3 2/2] DT: iio: vadc: document dt binding
References: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com> <1411563415-11933-3-git-send-email-svarbanov@mm-sol.com> <5439B7A8.9030306@gmx.de>
In-Reply-To: <5439B7A8.9030306@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments!

On 10/12/2014 02:05 AM, Hartmut Knaack wrote:
> Hi,
> two small issues inline.
> Stanimir Varbanov schrieb am 24.09.2014 14:56:
>> Document DT binding for Qualcomm SPMI PMIC voltage ADC
>> driver.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>> ---
>>  .../devicetree/bindings/iio/adc/qcom,spmi-vadc.txt |  130 ++++++++++++++++++++
>>  1 files changed, 130 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
>> new file mode 100644
>> index 0000000..fa30300
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-vadc.txt
>> @@ -0,0 +1,130 @@
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
>> +    Usage: optional
>> +    Value type: <prop-encoded-array>
>> +    Definition: End of conversion interrupt number. If this property does
>> +            not exist polling will be used instead.
>> +
>> +- interrupt-names:
>> +    Usage: optional
>> +    Value type: <string>
>> +    Definition: Should contain the interrupt name "eoc" (end of conversion).
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
> Missing whitespace before opening parenthesis.
>> +            calibration. If property is not found, channel will be
>> +            calibrated with 625mV and 1.25V reference channels.
> There is a slight majority in using V instead of mv (2 : 1), so why not express everything in V?

No worries, will correct.

-- 
regards,
Stan
