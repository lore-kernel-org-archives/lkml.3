Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaKRMwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:52:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54973 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaKRMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:52:15 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-ba-546b40fc02fb
Message-id: <546B40FA.2070409@samsung.com>
Date: Tue, 18 Nov 2014 13:52:10 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com> <20141118084603.GC4059@amd>
 <546B19C8.2090008@samsung.com> <20141118113256.GA10022@amd>
In-reply-to: <20141118113256.GA10022@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xy7p/HLJDDM6c5LZY88LB4s78v6wW
	84+cY7V4/FXPov/NQlaLc69WMlo83fyYyWLT42usFpd3zWGz2PpmHaNFz4atrBazl/SzWCy9
	fpHJYuLp30wWd08dZbOYMH0ti0Xr3iPsFmf2r2SzeH3nEZPF8k8RFvuveDmIehw9/4rVY828
	NYwe375OYvF4f6OV3eNyXy+Tx6+2ucweO2fdZfdYufwLm8fhrwtZPDat6mTz2Lyk3mPvoR/s
	HitWf2f3+LxJLoAvissmJTUnsyy1SN8ugSuj6dZk5oIJqhUnrrxib2CcLtvFyMkhIWAice/E
	VTYIW0ziwr31QDYXh5DAUkaJF0/Ws0I4Hxkl3r/oZwep4hXQktj0/jEziM0ioCrxc+5TJhCb
	TcBQ4ueL12C2qECExJ/T+1gh6gUlfky+xwJiiwjIS2ztW8EMMpRZYBOLxPT9S8AahAXcJWbe
	uAS2QEjgOqPEisZsEJtTQFPiUvsPsDizgLXEyknbGCFseYnNa94yT2AUmIVkxywkZbOQlC1g
	ZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERLFX3cwLj1mdYhRgINRiYe3YWNWiBBrYllx
	Ze4hRgkOZiUR3nPdQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MfLvF/y1YLfn629aKyuRU59cc
	93xf7TUS1n7en+kvN73JQoapl99uT/lm6+xWrt1nzVb8Lr5U6DeHV0ZH7sq2zEc9TlP3b128
	zLk2orpxgkVb4eIfydfP5v8t/Bu8dtNK5ePPjqSp2PreSzh7UXKFBhNTwgmDLZu47xe57zyQ
	8C7+9VXHNGcXJZbijERDLeai4kQAlhrt7MACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 12:32 PM, Pavel Machek wrote:
>
>>>> I've already submitted a patch [1] that updates leds common bindings.
>>>> I hasn't been merged yet, as the related LED Flash class patch [2]
>>>> still needs some indicator leds related discussion [3].
>>>>
>>>> I think this is a good moment to discuss the flash related led common
>>>> bindings.
>>>
>>> Part of problem is that adp1653 is not regarded as "LED" device by
>>> current kernel driver.
>>
>> It doesn't prevent us from keeping the flash devices related
>> DT bindings unified across kernel subsystems. The DT bindings
>> docs for the adp1653 could just provide a reference to the
>> led/common.txt bindings. In the future, when LED Flash
>> class will be merged, all the V4L2 Flash drivers might be
>> moved to the LED subsystem to gain the LED subsystem support.
>
> Yeah, that makses sense.
>
>>> @@ -19,5 +30,10 @@ Examples:
>>>   system-status {
>>>   	       label = "Status";
>>>   	       linux,default-trigger = "heartbeat";
>>> +	       iout-torch = <500 500>;
>>> +	       iout-flash = <1000 1000>;
>>> +	       iout-indicator = <100 100>;
>>> +	       flash-timeout = <1000>;
>>> +
>>> 	...
>>>   };
>>>
>>> I don't get it; system-status describes single LED, why are iout-torch
>>> (and friends) arrays of two?
>>
>> Some devices can control more than one led. The array is for such
>> purposes. The system-status should be probably renamed to
>> something more generic for both common leds and flash leds,
>> e.g. system-led.
>
> No, sorry. The Documentation/devicetree/bindings/leds/common.txt
> describes binding for _one LED_. Yes, your device can have two leds,
> so your devices should have two such blocks in the device tree... Each
> led should have its own label and default trigger, for example. And I
> guess flash-timeout be per-LED, too.

I think that a device tree binding describes a single physical device.
No matter how many sub-leds a device controls, it is still one
piece of hardware.
default-trigger property should also be an array of strings.
I agree that flash-timeout should be per led - an array, similarly
as in case of iout's.

> Would it make sense to include "-uA" and "-usec" suffixes in the dt
> property names?

I don't see this type of naming anywhere. The documentation should
contain the information about units. Nonetheless I am not a device tree
specialist, so an opinion of the relevant maintainer will be welcome.

>>> Also, at least on adp1653, these are actually two leds -- white and
>>> red. Torch and flash is white led, indicator is red led.
>>
>> Then you should define three properties:
>>
>> iout-torch = <[uA]>;
>> iout-flash = <[uA]>;
>> iout-indicator = <[uA]>;
>>
>> iout-torch and iout-flash properties would determine the current
>> for the white led in the torch and flash modes respectively and
>> the iout-indicator property would determine the current for
>> the indicator led.
>
> Yes, that would work. I have used
>
> +               max-flash-timeout-usec = <500000>;
> +               max-flash-intensity-uA     = <320000>;
> +               max-torch-intensity-uA     =  <50000>;
> +               max-indicator-intensity-uA =  <17500>;
>
> . Which is pretty similar. (Actually, maybe the longer property names
> are easier to understand for more people?) (And yes, I should probably
> separate red and white led into separate groups).

Documentation of a binding should provide sufficient explanation
for the people to understand what a property is for.
And I would stay by arrays as argued above.

>>>> [2] http://www.spinics.net/lists/linux-media/msg83100.html
>>>> [3] http://www.spinics.net/lists/linux-leds/msg02472.html
>>>
>>> What device are you using for testing? Can you cc me on future
>>> patches?
>>
>> I am using max77693 [1] and aat1290 [2]. OK, I will add you on cc.
>
> Thanks for cc and thanks for links!
>
> I see max77693 has two different "white" leds, aat1290 has one "white"
> led, and neither of them has secondary red led for indication?

You're right.

>> The v4l2-flash sub-device registers with v4l2-async API
>> in a media device. Exemplary support for v4l2-flash
>> sub-devices is added to the exynos4-is driver in the patch [5].
>
> Thanks for the links. It seems that aside from moving adp1653 driver
> to device tree, it should be moved to the LED framework, but that's a
> topic for another patch.

Like I mentioned in the previous message the LED Flash class patch
isn't in its final shape yet. Nonetheless I think that we should
agree on the leds/common.txt documentation improvements and
define DT documentation for adp1653 accordingly.

Regards,
Jacek
