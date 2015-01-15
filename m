Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbbAOOYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:24:55 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44959 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbAOOYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:24:52 -0500
MIME-Version: 1.0
In-Reply-To: <54B4DA81.7060900@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com> <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com> <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <54B4DA81.7060900@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 15 Jan 2015 08:24:26 -0600
Message-ID: <CAL_JsqLYxB5hzLAWXpU=uncM5DEMZU78mP673H9oSSNB-cgcYQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, sakari.ailus@iki.fi,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 2:42 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> On 01/12/2015 05:55 PM, Rob Herring wrote:
>>
>> Adding Mark B and Liam...
>>
>> On Mon, Jan 12, 2015 at 10:10 AM, Jacek Anaszewski
>> <j.anaszewski@samsung.com> wrote:
>>>
>>> On 01/12/2015 02:52 PM, Rob Herring wrote:
>>>>
>>>>
>>>> On Mon, Jan 12, 2015 at 2:32 AM, Jacek Anaszewski
>>>> <j.anaszewski@samsung.com> wrote:
>>>>>
>>>>> On 01/09/2015 07:33 PM, Rob Herring wrote:
>>>>>>
>>>>>> On Fri, Jan 9, 2015 at 9:22 AM, Jacek Anaszewski
>>>>>> <j.anaszewski@samsung.com> wrote:
>>>>>>>
>>>>>>> Add a property for defining the device outputs the LED
>>>>>>> represented by the DT child node is connected to.
>>
>>
>> [...]
>>
>>>>>>> b/Documentation/devicetree/bindings/leds/common.txt
>>>>>>> index a2c3f7a..29295bf 100644
>>>>>>> --- a/Documentation/devicetree/bindings/leds/common.txt
>>>>>>> +++ b/Documentation/devicetree/bindings/leds/common.txt
>>>>>>> @@ -1,6 +1,10 @@
>>>>>>>     Common leds properties.
>>>>>>>
>>>>>>>     Optional properties for child nodes:
>>>>>>> +- led-sources : Array of bits signifying the LED current regulator
>>>>>>> outputs the
>>>>>>> +               LED represented by the child node is connected to (1
>>>>>>> -
>>>>>>> the LED
>>>>>>> +               is connected to the output, 0 - the LED isn't
>>>>>>> connected
>>>>>>> to the
>>>>>>> +               output).
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Sorry, I just don't understand this.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> In some Flash LED devices one LED can be connected to one or more
>>>>> electric current outputs, which allows for multiplying the maximum
>>>>> current allowed for the LED. Each sub-LED is represented by a child
>>>>> node in the DT binding of the Flash LED device and it needs to declare
>>>>> which outputs it is connected to. In the example below the led-sources
>>>>> property is a two element array, which means that the flash LED device
>>>>> has two current outputs, and the bits signify if the LED is connected
>>>>> to the output.
>>>>
>>>>
>>>>
>>>> Sounds like a regulator for which we already have bindings for and we
>>>> have a driver for regulator based LEDs (but no binding for it).
>>>
>>>
>>>
>>> Do you think of drivers/leds/leds-regulator.c driver? This driver just
>>> allows for registering an arbitrary regulator device as a LED subsystem
>>> device.
>>>
>>> There are however devices that don't fall into this category, i.e. they
>>> have many outputs, that can be connected to a single LED or to many LEDs
>>> and the driver has to know what is the actual arrangement.
>>
>>
>> We may need to extend the regulator binding slightly and allow for
>> multiple phandles on a supply property, but wouldn't something like
>> this work:
>>
>> led-supply = <&led-reg0>, <&led-reg1>, <&led-reg2>, <&led-reg3>;
>>
>> The shared source is already supported by the regulator binding.
>
>
> I think that we shouldn't split the LED devices into power supply
> providers and consumers as in case of generic regulators. From this
> point of view a LED device current output is a provider and a discrete
> LED element is a consumer. In this approach each discrete LED element
> should have a related driver which is not how LED devices are being
> handled in the LED subsystem, where there is a single binding for a LED
> device and there is a single driver for it which creates separate LED
> class devices for each LED connected to the LED device output. Each
> discrete LED is represented by a child node in the LED device binding.
>
> I am aware that it may be tempting to treat LED devices as common
> regulators, but they have their specific features which gave a
> reason for introducing LED class for them. Besides, there is already
> drivers/leds/leds-regulator.c driver for LED devices which support only
> turning on/off and setting brightness level.
>
> In your proposition a separate regulator provider binding would have
> to be created for each current output and a separate binding for
> each discrete LED connected to the LED device. It would create
> unnecessary noise in a dts file.
>
> Moreover, using regulator binding implies that we want to treat it
> as a sheer power supply for our device (which would be a discrete LED
> element in this case), whereas LED devices provide more features like
> blinking pattern and for flash LED devices - flash timeout, external
> strobe and flash faults.

Okay, fair enough. Please include some of this explanation in the
binding description.

I do still have some concerns about led-sources and whether it can
support other scenarios. It is very much tied to the parent node. Are
there any cases where we don't want the LEDs to be sub nodes? Perhaps
the LEDs are on a separate daughterboard from the driver/supply and we
can have different drivers. It's a stretch maybe. Or are there cases
where you need more information than just the connection?

Rob
