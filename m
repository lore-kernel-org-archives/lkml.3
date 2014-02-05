Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaBEEw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:52:28 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35508 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaBEEw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:52:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140205044335.GA2172@beef>
References: <1391570096-2932-1-git-send-email-mranostay@gmail.com>
	<20140205044335.GA2172@beef>
Date: Tue, 4 Feb 2014 20:52:26 -0800
Message-ID: <CAKzfze-mHkxmnb06jDuD=-Zg3SmhRoZo6-P0D9dReA-gDwbTnw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] iio:as3935: Add DT binding docs for AS3935 driver
From: Matt Ranostay <mranostay@gmail.com>
To: Matt Porter <mporter@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 8:43 PM, Matt Porter <mporter@linaro.org> wrote:
> On Tue, Feb 04, 2014 at 07:14:55PM -0800, Matt Ranostay Matt Ranostay wrote:
>> Document compatible string, required and optional DT properties for
>> AS3935 chipset driver.
>>
>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>> ---
>>  .../devicetree/bindings/iio/proximity/as3935.txt   | 25 ++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iio/proximity/as3935.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iio/proximity/as3935.txt b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> new file mode 100644
>> index 0000000..7e117cd
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> @@ -0,0 +1,25 @@
>> +Austrian Microsystems AS3935 Franklin lightning sensor device driver
>> +
>> +Required properties:
>> +     - compatible: must be "ams,as3935"
>
> Change this to "amstaos,as3935"
>
> amstaos (AMS bought Taos) is already a registered vendor prefix in
> vendor-prefixes.txt
>
>> +     - reg: SPI chip select number for the device
>> +     - spi-cpha: SPI Mode 1
>
> When using generic binding properties, please reference the binding
> being used. Like:
>
>         - spi-cpha: SPI Mode 1. Refer to spi/spi-bus.txt for generic SPI
>           slave node bindings.
>
Noted.

>> +     - interrupt-parent : should be the phandle for the interrupt controller
>> +     - interrupts : interrupt mapping for GPIO IRQ
>
>         Refer to interrupt-controller/interrupts.txt for generic
>         interrupt client node bindings.
>
Noted.

>> +
>> +Optional properties:
>> +     - ams,tune-cap: Calibration tuning capacitor stepping value 0 - 15.
>> +       Range of 0 to 120 pF, 8pF steps. This will require using the
>> +       calibration data from the manufacturer.
>> +
>> +
>> +Example:
>> +
>> +as3935@0 {
>> +     compatible = "ams,as3935";
>> +     reg = <0>;
>> +     spi-cpha;
>> +     interrupt-parent = <&gpio1>;
>> +     interrupts = <16 1>;
>> +     ams,tune-cap = /bits/ 8 <10>;
>
> What is this? Why not just ams,tune-cap = <10>; ?
>
> It's a value between 0-15, right?

Correct but it is using of_property_read_u8() so that requires the
/bits/ statement.
Should this just be a u32 value?

>
> -Matt
