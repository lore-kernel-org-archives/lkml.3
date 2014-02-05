Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaBELEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 06:04:12 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:46065 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaBELEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:04:09 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAKzfze8d7uzwmTByJD-jmZszeD7fr=1k0y0jdCLU92wNOD=NMg@mail.gmail.com>
References: <1391570096-2932-1-git-send-email-mranostay@gmail.com> <20140205044335.GA2172@beef> <634e62ea-d33f-42f3-8500-6331d4de495d@email.android.com> <CAKzfze8d7uzwmTByJD-jmZszeD7fr=1k0y0jdCLU92wNOD=NMg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v4 1/2] iio:as3935: Add DT binding docs for AS3935 driver
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 05 Feb 2014 10:58:18 +0000
To: Matt Ranostay <mranostay@gmail.com>
CC: Matt Porter <mporter@linaro.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Message-ID: <2072f753-6b83-4983-8434-709e35dded3b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On February 5, 2014 10:22:24 AM GMT+00:00, Matt Ranostay <mranostay@gmail.com> wrote:
>On Tue, Feb 4, 2014 at 11:24 PM, Jonathan Cameron <jic23@kernel.org>
>wrote:
>>
>>
>> On February 5, 2014 4:43:35 AM GMT+00:00, Matt Porter
><mporter@linaro.org> wrote:
>>>On Tue, Feb 04, 2014 at 07:14:55PM -0800, Matt Ranostay Matt Ranostay
>>>wrote:
>>>> Document compatible string, required and optional DT properties for
>>>> AS3935 chipset driver.
>>>>
>>>> Signed-off-by: Matt Ranostay <mranostay@gmail.com>
>>>> ---
>>>>  .../devicetree/bindings/iio/proximity/as3935.txt   | 25
>>>++++++++++++++++++++++
>>>>  1 file changed, 25 insertions(+)
>>>>  create mode 100644
>>>Documentation/devicetree/bindings/iio/proximity/as3935.txt
>>>>
>>>> diff --git
>>>a/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>>>b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>>>> new file mode 100644
>>>> index 0000000..7e117cd
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/iio/proximity/as3935.txt
>>>> @@ -0,0 +1,25 @@
>>>> +Austrian Microsystems AS3935 Franklin lightning sensor device
>driver
>>>> +
>>>> +Required properties:
>>>> +    - compatible: must be "ams,as3935"
>>>
>>>Change this to "amstaos,as3935"
>>>
>>>amstaos (AMS bought Taos) is already a registered vendor prefix in
>>>vendor-prefixes.txt
>>
>> It is but has a rather separate presence and is not where people
>expect to find non light
>>  sensor stuff from ams. I personally would go for a new vendor prefix
>and stick with ams.
>>
>
>So should I add to vendor-prefixes.txt as well? or not?
Yes. All vendor prefixes should be in there
>
>>>
>>>> +    - reg: SPI chip select number for the device
>>>> +    - spi-cpha: SPI Mode 1
>>>
>>>When using generic binding properties, please reference the binding
>>>being used. Like:
>>>
>>>       - spi-cpha: SPI Mode 1. Refer to spi/spi-bus.txt for generic
>SPI
>>>         slave node bindings.
>>>
>>>> +    - interrupt-parent : should be the phandle for the interrupt
>>>controller
>>>> +    - interrupts : interrupt mapping for GPIO IRQ
>>>
>>>       Refer to interrupt-controller/interrupts.txt for generic
>>>       interrupt client node bindings.
>>>
>>>> +
>>>> +Optional properties:
>>>> +    - ams,tune-cap: Calibration tuning capacitor stepping value 0
>- 15.
>>>> +      Range of 0 to 120 pF, 8pF steps. This will require using the
>>>> +      calibration data from the manufacturer.
>>>> +
>>>> +
>>>> +Example:
>>>> +
>>>> +as3935@0 {
>>>> +    compatible = "ams,as3935";
>>>> +    reg = <0>;
>>>> +    spi-cpha;
>>>> +    interrupt-parent = <&gpio1>;
>>>> +    interrupts = <16 1>;
>>>> +    ams,tune-cap = /bits/ 8 <10>;
>>>
>>>What is this? Why not just ams,tune-cap = <10>; ?
>>>
>>>It's a value between 0-15, right?
>>>
>>>-Matt
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe linux-iio"
>in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> Sent from my Android phone with K-9 Mail. Please excuse my brevity.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
