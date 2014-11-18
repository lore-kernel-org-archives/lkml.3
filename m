Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaKRQCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:02:22 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52344 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaKRQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:02:19 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-c3-546b6d88aea0
Message-id: <546B6D86.8090701@samsung.com>
Date: Tue, 18 Nov 2014 17:02:14 +0100
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
 <546B40FA.2070409@samsung.com> <20141118132159.GA21089@amd>
In-reply-to: <20141118132159.GA21089@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t/xK7odudkhBqebWC3WvHCwuDP/L6vF
	/CPnWC0ef9Wz6H+zkNXi3KuVjBZPNz9mstj0+BqrxeVdc9gstr5Zx2jRs2Erq8XsJf0sFkuv
	X2SymHj6N5PF3VNH2SwmTF/LYtG69wi7xZn9K9ksXt95xGSx/FOExf4rXg6iHkfPv2L1WDNv
	DaPHt6+TWDze32hl97jc18vk8attLrPHzll32T1WLv/C5nH460IWj02rOtk8Ni+p99h76Ae7
	x4rV39k9Pm+SC+CL4rJJSc3JLEst0rdL4Mp4eeEUW8FEjYpN8xYxNjCukO9i5OSQEDCRuLh4
	KhOELSZx4d56ti5GLg4hgaWMEqfWXodyPjJKzNr6grWLkYODV0BLYt5rXpAGFgFViUW3v7CA
	2GwChhI/X7wGGyQqECHx5/Q+VhCbV0BQ4sfke2A1IgLyElv7VjCDzGQW2MQiMX3/ErAGYQF3
	iZk3LrFDLJvKJPF05lp2kASngKZE+/c5YEXMAtYSKydtY4Sw5SU2r3nLPIFRYBaSJbOQlM1C
	UraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgUf93BuPSY1SFGAQ5GJR7eho1ZIUKs
	iWXFlbmHGCU4mJVEeM91A4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwumStyOhor28p91m92bPk
	7G+5dfovMq5+SPebNbv+6bemE4v1LbJ4rX+91r8d9H3lQsUvPJttwlfcO+rTsmEH05pauync
	ch7/PSWyklYuWJBtVBHCeG7Fj6n923ZpPZn25fPWZG0Dzn1HI7hmf+lrX2WwQ/DBjN/pIc1r
	RWctylX71dG3JzgnWImlOCPRUIu5qDgRAAEShRDAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 11/18/2014 02:21 PM, Pavel Machek wrote:
> Hi!
>
>>>>> @@ -19,5 +30,10 @@ Examples:
>>>>>   system-status {
>>>>>   	       label = "Status";
>>>>>   	       linux,default-trigger = "heartbeat";
>>>>> +	       iout-torch = <500 500>;
>>>>> +	       iout-flash = <1000 1000>;
>>>>> +	       iout-indicator = <100 100>;
>>>>> +	       flash-timeout = <1000>;
>>>>> +
>>>>> 	...
>>>>>   };
>>>>>
>>>>> I don't get it; system-status describes single LED, why are iout-torch
>>>>> (and friends) arrays of two?
>>>>
>>>> Some devices can control more than one led. The array is for such
>>>> purposes. The system-status should be probably renamed to
>>>> something more generic for both common leds and flash leds,
>>>> e.g. system-led.
>>>
>>> No, sorry. The Documentation/devicetree/bindings/leds/common.txt
>>> describes binding for _one LED_. Yes, your device can have two leds,
>>> so your devices should have two such blocks in the device tree... Each
>>> led should have its own label and default trigger, for example. And I
>>> guess flash-timeout be per-LED, too.
>>
>> I think that a device tree binding describes a single physical device.
>> No matter how many sub-leds a device controls, it is still one
>> piece of hardware.
>
> You got this wrong, sorry.
>
> In my case, there are three physical devices:
>
> adp1653
> 	white LED
> 	red LED

You've mentioned that your white led is torch/flash and indicator
is the red led. They are probably connected to the HPLED and
ILED pins of the ADP1653 device respectively. The device is just
a regulator, that delivers electric current to the leds connected
to it. Kernel cannot directly activate leds, but has to talk
to the device through I2C bus. One I2C device can have only one
related device tree binding.

> Each LED should have an label, and probably default trigger -- default
> trigger for red one should be "we are recording video" and for white
> should be "this is flash for default camera".

default-trigger is not mandatory, the device doesn't have to have
associated led-trigger. I think that you should look at
Documentation/leds/leds-class.txt and drivers/leds/triggers for
more detailed information. In a nutshell triggers are kernel
sources of led events. You can set e.g. "heartbeat", "timer"
trigger etc.
As for now the driver belongs to the V4L2 subsystem it doesn't
support triggers. Moreover your event "we are recording a video"
should be activated by setting V4L2_CID_FLASH_INDICATOR_INTENSITY
v4l2 control followed by V4L2_FLASH_LED_MODE_TORCH. Your event
"this is flash for default camera" seems to be flash strobe,
that can be activated by setting V4L2_CID_FLASH_STROBE control.
The driver by default sets the indicator current for both actions
to the value previously set with V4L2_CID_FLASH_INDICATOR_INTENSITY.

> If the hardware LED changes with one that needs different current, the
> block for the adp1653 stays the same, but white LED block should be
> updated with different value.

I think that you are talking about sub nodes. Indeed I am leaning
towards this type of design.

>> default-trigger property should also be an array of strings.
>
> That is not how it currently works.

OK, I agree.

>
>> I agree that flash-timeout should be per led - an array, similarly
>> as in case of iout's.
>
> Agreed about per-led, disagreed about the array. As all the fields
> would need arrays, and as LED system currently does not use arrays for
> label and linux,default-trigger, I believe we should follow existing
> design and model it as three devices. (It _is_ physically three devices.)

Right, I missed that the leds/common.txt describes child node.

I propose following modifications to the binding:

Optional properties for child nodes:
- iout-mode-led : 	maximum intensity in microamperes of the LED
		  	(torch LED for flash devices)
- iout-mode-flash : 	initial intensity in microamperes of the
			flash LED; it is required to enable support
			for the flash led
- iout-mode-indicator : initial intensity in microamperes of the
			indicator LED; it is required to enable support
			for the indicator led
- max-iout-mode-led : 	maximum intensity in microamperes of the LED
		  	(torch LED for flash devices)
- max-iout-mode-flash : maximum intensity in microamperes of the
			flash LED
- max-iout-mode-indicator : maximum intensity in microamperes of the
			indicator LED
- flash-timeout :	timeout in microseconds after which flash
			led is turned off

system-status {
         label = "max77693_1";
         iout-mode-led = <500>;
         max-iout-mode-led = <500>;
         ...
};

camera-flash1 {
         label = "max77693_2";
         iout-mode-led = <500>;
         iout-mode-flash = <1000>;
	iout-mode-indicator = <100>;
         max-iout-mode-led = <500>;
         max-iout-mode-flash = <1000>;
         max-iout-mode-indicator = <100>;
         flash-timeout = <1000>;
         ...
};


I propose to avoid name "torch", as for ordinary leds it would
be misleading.

Regards,
Jacek
