Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab3HML7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:59:09 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:63101 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757512Ab3HML7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:59:07 -0400
Message-ID: <520A1F20.60401@metafoo.de>
Date: Tue, 13 Aug 2013 13:57:20 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
CC: Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, jic23@cam.ac.uk
Subject: Re: [PATCH v2] iio: add Bosch BMA180 acceleration sensor driver
References: <1376384956-16720-1-git-send-email-o.v.kravchenko@globallogic.com> <alpine.DEB.2.01.1308131131170.30839@pmeerw.net> <CAGH3drr2p5dD4SXxG67QChVH1wubRCDKWaQPevQKBxej-UqsBA@mail.gmail.com>
In-Reply-To: <CAGH3drr2p5dD4SXxG67QChVH1wubRCDKWaQPevQKBxej-UqsBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 01:22 PM, Oleksandr Kravchenko wrote:
> On Tue, Aug 13, 2013 at 1:01 PM, Peter Meerwald <pmeerw@pmeerw.net> wrote:
>>
>>> This patch adds IIO driver for Bosch BMA180 triaxial
>>> acceleration sensor.
>>> http://omapworld.com/BMA180_111_1002839.pdf
>>
>> the DS is preliminary, more up-to-date version available
>>
>> comments inline
>>
>>> ---
>>>   .../devicetree/bindings/iio/accel/bma180.txt       |   35 ++
>>>   drivers/iio/accel/Kconfig                          |   12 +
>>>   drivers/iio/accel/Makefile                         |    2 +
>>>   drivers/iio/accel/bma180.c                         |  635 ++++++++++++++++++++
>>>   4 files changed, 684 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/iio/accel/bma180.txt
>>>   create mode 100644 drivers/iio/accel/bma180.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/iio/accel/bma180.txt b/Documentation/devicetree/bindings/iio/accel/bma180.txt
>>> new file mode 100644
>>> index 0000000..e08780b
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/iio/accel/bma180.txt
>>> @@ -0,0 +1,35 @@
>>> +* Bosch BMA180 triaxial acceleration sensor
>>> +
>>> +http://omapworld.com/BMA180_111_1002839.pdf
>>> +
>>> +Required properties:
>>> +
>>> +  - compatible : should be "bosch,bma180"
>>> +  - reg : the I2C address of the sensor
>>> +
>>> +Optional properties:
>>> +
>>> +  - interrupt-parent : should be the phandle for the interrupt controller
>>> +
>>> +  - interrupts : interrupt mapping for GPIO IRQ, it should by configured with
>>> +             flags IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING
>>> +
>>> +  - bosch,resolution : ADC resolution. Must be 130, 190, 250, 380, 500,
>>> +             990 or 1980 mcg/LSB only
>>
>> what is mcg?
> mcg is microgram (http://en.wikipedia.org/wiki/Kilogram#SI_multiples)
> How to call it more correctly?

I would be very surprised if g was gram. g is usually acceleration in this 
context, 9.81m/s**2

But again same question as before, shouldn't this rather be runtime 
configurable? Same for bandwidth.

- Lars

- Lars
