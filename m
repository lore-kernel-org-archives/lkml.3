Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaBIXQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 18:16:36 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:56362 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaBIXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 18:16:22 -0500
MIME-Version: 1.0
In-Reply-To: <52F7F92E.9040508@kernel.org>
References: <1391670015-6551-1-git-send-email-mranostay@gmail.com>
	<1391670015-6551-2-git-send-email-mranostay@gmail.com>
	<52F7F92E.9040508@kernel.org>
Date: Sun, 9 Feb 2014 15:16:21 -0800
Message-ID: <CAKzfze-VGEVJWgqJC-87KVbrFie9_CZP6wU1sTCjPuvc0XxJAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] iio:as3935: Add DT binding docs for AS3935 driver
From: Matt Ranostay <mranostay@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, Matt Porter <matt.porter@linaro.org>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 1:54 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 06/02/14 07:00, Matt Ranostay wrote:
>>
>> Document compatible string, required and optional DT properties for
>> AS3935 chipset driver.
>>
>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>> ---
>>   .../devicetree/bindings/iio/proximity/as3935.txt   | 28
>> ++++++++++++++++++++++
>>   .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>>   2 files changed, 29 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/iio/proximity/as3935.txt
>>
>> diff --git a/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> new file mode 100644
>> index 0000000..574d49c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> @@ -0,0 +1,28 @@
>> +Austrian Microsystems AS3935 Franklin lightning sensor device driver
>> +
>> +Required properties:
>> +       - compatible: must be "ams,as3935"
>> +       - reg: SPI chip select number for the device
>> +       - spi-cpha: SPI Mode 1. Refer to spi/spi-bus.txt for generic SPI
>> +       slave node bindings.
>> +       - interrupt-parent : should be the phandle for the interrupt
>> controller
>> +       - interrupts : interrupt mapping for GPIO IRQ
>
> Why does it need to be a GPIO IRQ?  As far as I can see any irq will do
> (note there are devices that provide suitable interrupts without the ability
> to read the level).  Oops, we have a couple of other IIO bindings stating
> exactly this.  I doubt they need to be GPIOs either.
>
No it doesn't it can be any interrupt type... Will reword better


>
>> +
>> +       Refer to interrupt-controller/interrupts.txt for generic
>> +       interrupt client node bindings.
>> +
>> +Optional properties:
>> +       - ams,tune-cap: Calibration tuning capacitor stepping value 0 -
>> 15.
>> +         Range of 0 to 120 pF, 8pF steps. This will require using the
>> +         calibration data from the manufacturer.
>
> Why not have this as the actual value rather than a magic number?  Might
> as well keep the device tree as human readable as possible.
>

Makes sense.

>> +
>> +Example:
>> +
>> +as3935@0 {
>> +       compatible = "ams,as3935";
>> +       reg = <0>;
>> +       spi-cpha;
>> +       interrupt-parent = <&gpio1>;
>> +       interrupts = <16 1>;
>> +       ams,tune-cap = <10>;
>> +};
>> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> index 3c31b40..9dd66ca 100644
>> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
>> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
>> @@ -10,6 +10,7 @@ aeroflexgaisler       Aeroflex Gaisler AB
>>   ak    Asahi Kasei Corp.
>>   altr  Altera Corp.
>>   amcc  Applied Micro Circuits Corporation (APM, formally AMCC)
>> +ams    AMS AG
>>   amstaos       AMS-Taos Inc.
>>   apm   Applied Micro Circuits Corporation (APM)
>>   arm   ARM Ltd.
>>
>
