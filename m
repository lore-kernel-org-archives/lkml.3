Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaBEHYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 02:24:47 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43397 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaBEHYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 02:24:45 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140205044335.GA2172@beef>
References: <1391570096-2932-1-git-send-email-mranostay@gmail.com> <20140205044335.GA2172@beef>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v4 1/2] iio:as3935: Add DT binding docs for AS3935 driver
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 05 Feb 2014 07:24:37 +0000
To: Matt Porter <mporter@linaro.org>, Matt Ranostay <mranostay@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@gmail.com
Message-ID: <634e62ea-d33f-42f3-8500-6331d4de495d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On February 5, 2014 4:43:35 AM GMT+00:00, Matt Porter <mporter@linaro.org> wrote:
>On Tue, Feb 04, 2014 at 07:14:55PM -0800, Matt Ranostay Matt Ranostay
>wrote:
>> Document compatible string, required and optional DT properties for
>> AS3935 chipset driver.
>> 
>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>> ---
>>  .../devicetree/bindings/iio/proximity/as3935.txt   | 25
>++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>  create mode 100644
>Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> 
>> diff --git
>a/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> new file mode 100644
>> index 0000000..7e117cd
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>> @@ -0,0 +1,25 @@
>> +Austrian Microsystems AS3935 Franklin lightning sensor device driver
>> +
>> +Required properties:
>> +	- compatible: must be "ams,as3935"
>
>Change this to "amstaos,as3935"
>
>amstaos (AMS bought Taos) is already a registered vendor prefix in
>vendor-prefixes.txt

It is but has a rather separate presence and is not where people expect to find non light
 sensor stuff from ams. I personally would go for a new vendor prefix and stick with ams.

>
>> +	- reg: SPI chip select number for the device
>> +	- spi-cpha: SPI Mode 1
>
>When using generic binding properties, please reference the binding
>being used. Like:
>
>	- spi-cpha: SPI Mode 1. Refer to spi/spi-bus.txt for generic SPI
>	  slave node bindings.
>
>> +  	- interrupt-parent : should be the phandle for the interrupt
>controller
>> +	- interrupts : interrupt mapping for GPIO IRQ
>
>	Refer to interrupt-controller/interrupts.txt for generic
>	interrupt client node bindings.
>
>> +
>> +Optional properties:
>> +	- ams,tune-cap: Calibration tuning capacitor stepping value 0 - 15.
>> +	  Range of 0 to 120 pF, 8pF steps. This will require using the
>> +	  calibration data from the manufacturer.
>> +
>> +
>> +Example:
>> +
>> +as3935@0 {
>> +	compatible = "ams,as3935";
>> +	reg = <0>;
>> +	spi-cpha;
>> +	interrupt-parent = <&gpio1>;
>> +	interrupts = <16 1>;
>> +	ams,tune-cap = /bits/ 8 <10>;
>
>What is this? Why not just ams,tune-cap = <10>; ?
>
>It's a value between 0-15, right?
>
>-Matt
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
