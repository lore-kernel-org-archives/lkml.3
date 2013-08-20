Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab3HTLky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:40:54 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:34598 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3HTLkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130820091228.GW3719@e106331-lin.cambridge.arm.com>
References: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com>
	<20130820091228.GW3719@e106331-lin.cambridge.arm.com>
Date: Tue, 20 Aug 2013 14:40:50 +0300
Message-ID: <CAPb7_mt7K7SK7RXerKJKMhsTQZPZ7AKx0pxQLvWawVV9GK-+oA@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
From: Oleksandr Kozaruk <oleksandr.kozaruk@globallogic.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Aug 20, 2013 at 12:12 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi Oleksandr,
>
> [Adding Jonathan Cameron and Guenter Roeck to Cc]
>
> Apologies for the delay replying to this. In attempting to verify this
> made sense I went and read the IIO bindings documentation, and I'm
> somewhat confused by the model.
>
> As far as I can see, the only consumer of IIO channels is the
> "iio-hwmon" binding, which seems to be a binding for Linux-specific
> infrastructure rather than any actual device. This runs counter to the
> way DT is supposed to function (describing the hardware rather than how
> it's used). As far as I can see, this linkage is described because only
> a subset of the ADCs on the device are actually wired to something?
>
> I also see a couple of IIO bindings ("adi,adf435x*, and "adi,ad7303")
> which don't describe any iio channel cells at all, so I'm somewhat
> confused by what the IIO channels actually represent, and why they must
> be consumed elsewhere. As far as I can see, an IIO channel represents a
> single ADC's registers in an IIO device, so I'm not sure why this must
> be exported via the channel concept -- it's not physically wired.

The GPADC was used by battery driver and thermal subsystem.
In our local pre-DT branch battery driver reads channels 1 (battery
temperature),
7 (battery voltage), and 8 (battery backup voltage)

I'm guessing a consumer would be in some_board.dts, and describe it as
    battery_consumer {
            ....
            io-channels = <&adc 1>, <&adc 7>, <&adc 8>;
            ...
    }

The purpose of the channels is not arbitrary but dedicated to certain functions
in twl6030.

Regards,
Sasha.

>
> Have I misunderstood something here?
>
> Thanks,
> Mark.
>
> On Mon, Aug 19, 2013 at 12:29:25PM +0100, Oleksandr Kozaruk wrote:
>> Add required documentation for twl6030 GPADC device tree
>> bindings.
>>
>> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
>> ---
>>  .../devicetree/bindings/iio/adc/twl6030-gpadc.txt  | 45 ++++++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
>> new file mode 100644
>> index 0000000..6cd3ef3
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/adc/twl6030-gpadc.txt
>> @@ -0,0 +1,45 @@
>> +Texas Instruments twl6030/twl6032 GPADC device driver
>> +
>> +Required properties:
>> +     - compatible: must be "ti,twl6030-gpadc" for TWL6030 or
>> +       "ti,twl6032-gpadc" for TWL6032
>> +     - interrupts: interrupt number associated with it
>> +     - #io-channel-cells: must be <1> - multiple IIO outputs are present
>> +       iio consumers can use following io-channels:
>> +             twl6030:
>> +                     0 - battery type
>> +                     1 - battery temperature resistor value
>> +                     2 - audio accessory/general purpose
>> +                     3 - general purpose
>> +                     4 - temperature/general purpose
>> +                     5 - general purpose
>> +                     6 - general purpose
>> +                     7 - main battery
>> +                     8 - backup battery
>> +                     9 - charger input
>> +                     10 - VBUS
>> +                     11 - VBUS charging current
>> +                     14 - USB ID
>> +             twl6032:
>> +                     0 - battery type
>> +                     1 - battery temperature resistor value
>> +                     2 - audio accessory/general purpose
>> +                     3 - temperature with external diode/general purpose
>> +                     4 - temperature/general purpose
>> +                     5 - general purpose
>> +                     6 - general purpose
>> +                     7 - system supply
>> +                     8 - backup battery
>> +                     9 - charger input
>> +                     10 - VBUS
>> +                     11 - VBUS charging current
>> +                     14 - USB ID
>> +                     17 - battery charging current
>> +                     18 - battery voltage
>> +
>> +Example:
>> +     adc {
>> +             compatible = "ti,twl6030-gpadc";
>> +             interrupts = <3>;
>> +             #io-channel-cells = <1>;
>> +     };
>> --
>> 1.8.1.2
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards,
Oleksandr Kozaruk | embedded developer
GlobalLogic
M +38.067.944.7905
www.globallogic.com

http://www.globallogic.com/email_disclaimer.txt
