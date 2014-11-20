Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaKTJWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:22:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45402 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbaKTJWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:22:04 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-dd-546db2b8c2bc
Message-id: <546DB2B4.1070909@samsung.com>
Date: Thu, 20 Nov 2014 10:21:56 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com> <20141118084603.GC4059@amd>
 <546B19C8.2090008@samsung.com> <20141118113256.GA10022@amd>
 <546B40FA.2070409@samsung.com> <20141118132159.GA21089@amd>
 <546B6D86.8090701@samsung.com> <20141118165148.GA11711@amd>
 <546C66A5.6060201@samsung.com> <546CD90B.8060903@iki.fi>
In-reply-to: <546CD90B.8060903@iki.fi>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t/xq7o7NuWGGHyfbWix5oWDxcYZ61kt
	7sz/y2ox/8g5VovHX/Us+t8sZLU492olo8XTzY+ZLDY9vsZqcXnXHDaLrW/WMVr0bNjKajF7
	ST+LxdLrF5ksJp7+zWRx99RRNosJ09eyWLTuPcJucWb/SjaL13ceMVks/xRhsf+Kl4OYx9Hz
	r1g91sxbw+jx7eskFo/3N1rZPS739TJ5/Gqby+yxc9Zddo+Vy7+weRz+upDFY9OqTjaPzUvq
	PfYe+sHu0bdlFaPHitXf2T0+b5IL4I/isklJzcksSy3St0vgythwfAF7wVWDio0rAhsYP6l2
	MXJySAiYSEx89pMJwhaTuHBvPVsXIxeHkMBSRoldf7ewQjgfGSUOnv4MVsUroCWx8t9qdhCb
	RUBV4vmeZmYQm03AUOLni9dgNaICERJ/Tu9jhagXlPgx+R4LiC0ioCbxdNNDFpChzAKPWSSm
	dVwBaxAWcJeYeeMSO8S2PmaJvw/2MYIkOIE6pi7eAzaJWcBM4lHLOmYIW15i85q3zBMYBWYh
	WTILSdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoRE9tcdjEuPWR1iFOBgVOLh
	vTArN0SINbGsuDL3EKMEB7OSCK/SEqAQb0piZVVqUX58UWlOavEhRiYOTqkGRrnnM3hWTbNT
	+JwWIHdF+aWsmXyX68VVIYorlh3yt5/xeP7xxSom62/UFYTPbraqWX2RP3rxxaR/Cfzr/Nb7
	XH2w6vgvZ8tLVXNqfh7glWjbIcm249RfvlK32NwQZZ9DzIUPxb27Uo19ijc1OS0WTAlXXzCj
	ee3O21vPGCs1Bn1mtvi9x/nuQyWW4oxEQy3mouJEAD+UsMbKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, Sakari,

On 11/19/2014 06:53 PM, Sakari Ailus wrote:
> Hi Jacek and Pavel,
>
> Jacek Anaszewski wrote:
>> Hi Pavel, Sakari,
>>
>> On 11/18/2014 05:51 PM, Pavel Machek wrote:
>>> Hi!
>>>
>>>>> If the hardware LED changes with one that needs different current, the
>>>>> block for the adp1653 stays the same, but white LED block should be
>>>>> updated with different value.
>>>>
>>>> I think that you are talking about sub nodes. Indeed I am leaning
>>>> towards this type of design.
>>>
>>> I think I am :-).
>>>
>>>>>> I agree that flash-timeout should be per led - an array, similarly
>>>>>> as in case of iout's.
>>>>>
>>>>> Agreed about per-led, disagreed about the array. As all the fields
>>>>> would need arrays, and as LED system currently does not use arrays for
>>>>> label and linux,default-trigger, I believe we should follow existing
>>>>> design and model it as three devices. (It _is_ physically three
>>>>> devices.)
>>>>
>>>> Right, I missed that the leds/common.txt describes child node.
>>>>
>>>> I propose following modifications to the binding:
>>>>
>>>> Optional properties for child nodes:
>>>> - iout-mode-led :     maximum intensity in microamperes of the LED
>>>>                (torch LED for flash devices)
>>>> - iout-mode-flash :     initial intensity in microamperes of the
>>>>              flash LED; it is required to enable support
>>>>              for the flash led
>>>> - iout-mode-indicator : initial intensity in microamperes of the
>>>>              indicator LED; it is required to enable support
>>>>              for the indicator led
>>>> - max-iout-mode-led :     maximum intensity in microamperes of the LED
>>>>                (torch LED for flash devices)
>>>> - max-iout-mode-flash : maximum intensity in microamperes of the
>>>>              flash LED
>>>> - max-iout-mode-indicator : maximum intensity in microamperes of the
>>>>              indicator LED
>>>> - flash-timeout :    timeout in microseconds after which flash
>>>>              led is turned off
>>>
>>> Ok, I took a look, and "iout" is notation I understand, but people may
>>> have trouble with and I don't see it used anywhere else.
>>>
>>> Also... do we need both "current" and "max-current" properties?
>>>
>>> But regulators already have "regulator-max-microamp" property. So what
>>> about:
>>>
>>> max-microamp :     maximum intensity in microamperes of the LED
>>>                  (torch LED for flash devices)
>>> max-flash-microamp :     initial intensity in microamperes of the
>>>                flash LED; it is required to enable support
>>>                for the flash led
>>> flash-timeout-microseconds : timeout in microseconds after which flash
>>>                led is turned off
>>>
>>> If you had indicator on the same led, I guess
>>>
>>> indicator-microamp : recommended intensity in microamperes of the LED
>>>                   for indication
>
> The value for the indicator is maximum as well, not just a recommendation.
>
>>>
>>> ...would do?
>>
>>
>> Ongoing discussion allowed me for taking a look at the indicator issue
>> from different perspective. This is also vital for the issue of
>> whether a v4l2-flash sub-device should be created per device or
>> per sub-led [1].
>>
>> Currently each sub-led is represented as a separate device tree
>> sub node and the led drivers create separate LED class device for the
>> sub nodes. What this implies is that indicator led also must be
>> represented by the separate LED class device.
>>
>> This is contrary to the way how V4L2 Flash API approaches this issue,
>> as it considers a flash device as a regulator chip driven through
>> a bus. The API allows to set the led in torch or flash mode and
>> implicitly assumes that there can be additional indicator led
>> supported, which can't be turned on separately, but the drivers apply
>> the indicator current to the indicator led when the torch or flash led
>> is activated.
>
> The indicator is independent of the flash LED in V4L2 flash API. At
> least that's how it should be, and in adp1653 the two are independent,
> but the as3645a can't use indicator with the flash AFAIR.

Right.

>> I propose to create separate v4l2-flash device for the indicator led,
>> and treat it as a regular sub-led similarly like it is done in the
>> LED subsystem. LED Flash class driver would only add a flag
>> LED_DEV_CAP_INDICATOR and basing on it the v4l2-flash sub-device
>> would create only V4L2_CID_FLASH_INDICATOR_INTENSITY control for it.
>> There could ba also additional control added:
>> V4L2_CID_FLASH_INDICATOR_PATTERN to support the feature
>> supported by some LED class drivers.
>
> Interesting idea.
>
> The flash controller is still a single I2C device with common set of
> faults, for instance. Some devices refuse to work again in case of
> faults until they are cleared (= read).

The V4L2_CID_FLASH_FAULT control should be also supported by the
indicator v4l2-flash sub-device then.

> Could the indicator pattern control be present in the same sub-device?

Yes, this was my intention. To conclude - the indicator v4l2-flash 
sub-device should support up to three controls:
- V4L2_CID_FLASH_TORCH_INTENSITY
- V4L2_CID_FLASH_FAULT
- V4L2_CID_FLASH_INDICATOR_PATTERN (if supported by the LED Flash
				    class driver)

V4L2_CID_FLASH_INDICATOR_PATTERN would be a menu control with
custom menu items.

> Are there any flash LED controllers that support such functionality?

There is: lm3556. LED subsystem leds-lm355x.c driver supports it.
The driver exposes dedicated sysfs attribute for setting the blinking
pattern (four possible options).

>>  From the media device perspective such an approach would
>> be harmful, as the indicator led could be turned on right
>> before strobing the flash or turning the torch on, by
>> separate calls to different v4l2-flash sub-devices.
>>
>> The design described above would allow for avoiding issues I touched
>> in the message [1].
>
> Let me reply this separately. Feel free to ping me if I obviously appear
> to miss something.
>

Best Regards,
Jacek Anaszewski
