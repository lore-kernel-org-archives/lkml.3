Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbbALNws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:52:48 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56679 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbbALNwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:52:46 -0500
MIME-Version: 1.0
In-Reply-To: <54B38682.5080605@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com> <54B38682.5080605@samsung.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 12 Jan 2015 07:52:24 -0600
Message-ID: <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
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
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 2:32 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> On 01/09/2015 07:33 PM, Rob Herring wrote:
>>
>> On Fri, Jan 9, 2015 at 9:22 AM, Jacek Anaszewski
>> <j.anaszewski@samsung.com> wrote:
>>>
>>> Add a property for defining the device outputs the LED
>>> represented by the DT child node is connected to.
>>>
>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Bryan Wu <cooloney@gmail.com>
>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>>> Cc: Kumar Gala <galak@codeaurora.org>
>>> ---
>>>   Documentation/devicetree/bindings/leds/common.txt |    5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/leds/common.txt
>>> b/Documentation/devicetree/bindings/leds/common.txt
>>> index a2c3f7a..29295bf 100644
>>> --- a/Documentation/devicetree/bindings/leds/common.txt
>>> +++ b/Documentation/devicetree/bindings/leds/common.txt
>>> @@ -1,6 +1,10 @@
>>>   Common leds properties.
>>>
>>>   Optional properties for child nodes:
>>> +- led-sources : Array of bits signifying the LED current regulator
>>> outputs the
>>> +               LED represented by the child node is connected to (1 -
>>> the LED
>>> +               is connected to the output, 0 - the LED isn't connected
>>> to the
>>> +               output).
>>
>>
>> Sorry, I just don't understand this.
>
>
> In some Flash LED devices one LED can be connected to one or more
> electric current outputs, which allows for multiplying the maximum
> current allowed for the LED. Each sub-LED is represented by a child
> node in the DT binding of the Flash LED device and it needs to declare
> which outputs it is connected to. In the example below the led-sources
> property is a two element array, which means that the flash LED device
> has two current outputs, and the bits signify if the LED is connected
> to the output.

Sounds like a regulator for which we already have bindings for and we
have a driver for regulator based LEDs (but no binding for it). Please
use the regulator binding.

> Do your doubts stem from the ambiguity of the word "current" or the
> form of the description itself is unclear? Probably there should be
> explicit explanation added that the size of the array depends on the
> number of current outputs of the flash LED device.

The size of the array and meaning of array indexes was not clear.

Rob

>
>
>>>   - label : The label for this LED.  If omitted, the label is
>>>     taken from the node name (excluding the unit address).
>>>
>>> @@ -33,6 +37,7 @@ system-status {
>>>
>>>   camera-flash {
>>>          label = "Flash";
>>> +       led-sources = <1 0>;
>>>          max-microamp = <50000>;
>>>          flash-max-microamp = <320000>;
>>>          flash-timeout-us = <500000>;
>>> --
>>> 1.7.9.5
>>>
>>
>
> --
> Best Regards,
> Jacek Anaszewski
