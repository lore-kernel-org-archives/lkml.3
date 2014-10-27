Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaJ0PwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:52:12 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52656 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ0PwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:52:09 -0400
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20141027152306.GV10262@pengutronix.de>
Date: Mon, 27 Oct 2014 17:52:02 +0200
Cc: atull@opensource.altera.com, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, Michal Simek <monstr@monstr.eu>,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <194BE134-7804-4E84-BD5D-AB9A5892ED6F@konsulko.com>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-3-git-send-email-atull@opensource.altera.com> <20141024070042.GL10262@pengutronix.de> <5FB7B7FD-7B5B-4250-BADE-85573FDBBE48@konsulko.com> <20141025144229.GR10262@pengutronix.de> <16E8EC52-0A91-4F28-8113-3CC5352215A5@konsulko.com> <20141027152306.GV10262@pengutronix.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steffen,

> On Oct 27, 2014, at 17:23 , Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
> 
> Hi!
> 
> On Mon, Oct 27, 2014 at 01:54:20PM +0200, Pantelis Antoniou wrote:
>> Hi Stefen,
>> 
>>> On Oct 25, 2014, at 17:42 , Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
>>> 
>>> Hi Pantelis!
>>> 
>>> On Fri, Oct 24, 2014 at 12:20:53PM +0300, Pantelis Antoniou wrote:
>>>> Hi Stefan, Allan,
>>>> 
>>>> Sorry, haven’t had a chance to review all this yet; will do so in the weekend.
>>>> Just wanted to pop in and comment on a few things.
>>>> 
>>>>> On Oct 24, 2014, at 10:00 AM, Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
>>>>> 
>>>>> Hi!
>>>>> 
>>>>> On Thu, Oct 23, 2014 at 06:51:06PM -0500, atull@opensource.altera.com wrote:
>>>>>> From: Alan Tull <atull@opensource.altera.com>
>>>>> 
>>>>> (...)
>>>>> 
>>>>>> diff --git a/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
>>>>>> new file mode 100644
>>>>>> index 0000000..bc24a2e
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
>>>>>> @@ -0,0 +1,53 @@
>>>>>> +Altera FPGA/HPS Bridge Driver
>>>>>> +
>>>>>> +This driver manages a bridge between a FPGA and a host processor system (HPS).
>>>>>> +User space can enable or disable the bridge by writing a "1" or a "0",
>>>>>> +respectively, to its enable file under bridge's entry in
>>>>>> +/sys/class/fpga-bridge.  Typically, one disables the bridges before
>>>>>> +reprogramming the FPGA.  Once the FPGA is reprogrammed, the bridges are
>>>>>> +reenabled.
>>>>>> +
>>>>> 
>>>>> NAK.
>>>>> 
>>>>> This is all linux specific and doesn't belong here.
>>>>> 
>>>> 
>>>> We know. The DT spec hasn’t been updated for a while, and this is going to be
>>>> part of what we want to do with the restarting of the ePAPR spec process.
>>>> 
>>> 
>>> As we don't have a new spec yet, I go with the current state of the art.
>>> And I don't see how "file under ... /sys/class/fpga-bridge" fits the
>>> current spec.
>>> 
>>>> So absolutes like “DT is a hardware description only" might be too strong statements, that
>>>> do not work in practice anymore.
>>>> 
>>>> There’s no such thing as pure hardware devices lately - there is always a configuration
>>>> component; some of it OS specific, some of it not.
>>>> 
>>> 
>>> If it really is necessary, I'm not against it, don't get me wrong.
>>> But in the grand scheme I wouldn't say that this fits my experience.
>>> There are some devices that need configuration and often when it is
>>> done in the DT, it is just a shortcut or not thought through.
>>> And can be also introspected dynamically. With some discussion on the
>>> list these bindings often change.
>>> 
>> 
>> Already answered and given a possible way this might work; admittedly this
>> specific example is not a good fit for what I was trying to say, but whatever.
>> Let’s get the ball rolling.
>> 
> 
> I would be okay with chosen-node. Not for this driver; but in general.
> 

Let’s figure out how to do it then…

>>> Regarding OS specifics: already there, e.g. console setup in the chosen node.
>>> And other things I saw are ethernet aliases just for u-boot. Not a problem
>>> of the spec, just a problem of u-boot and unneccessary "configuration".
>>> Just to fix a bad bootloader. barebox can handle this without any
>>> such stuff. Maybe we should integrate the DT "overlays" barebox uses into
>>> the in-kernel DTs as well...but does it really help/interest someone who
>>> decides to use u-boot where barebox stores its environment? I guess not.
>>> 
>> 
>> Although I’m not against having DT overlays in the bootloader, I only see them
>> as a method that helps a platform developer express things easier. I am completely
>> against having the kernel tied to any particular bootloader.
>> 
>> We’ve all been through the hell where a kernel only boots if the bootloader has 
>> setup the platform “correctly”. This “correctly” has a very loose definition and
>> 99/100 times is extremely badly documented or not at all.
>> 
>> IMHO the bootloader should (as part of the normal boot sequence) only setup the
>> absolutely bare minimum and then pass control to the kernel as soon as possible.
>> 
>> The full featured bootloader environment should only be presented when the user
>> requests so.
>> 
> 
> Totally agree. The kernel shouldn't be tied to any bootloader if at all possible
> (the SoCFPGA is an especially bad example here again, as the pinmuxing can only
> happen in the bootloader).

I’m not familiar with SoCFPGA. Why pinmuxing is only possible in the bootloader?
Can’t the bootloader configure the minimum pinmux config and then have Linux setup
the rest?

If we’re feeling particularly nasty, we might just require bootloaders to clean the
hardware state before passing control to Linux (besides memory controller setup) and
see what’s broken.

> But should the DT include stuff than, that is only interesting for linux?
> 

Like it or not it’s Linux that’s in the forefront of many hardware designs.

There are configuration settings in DT that are part of the way hardware is presented to
Linux and user-space, and have been for quite some time. We’ve been pretending they don’t
exist, but they are there…

We have a chance to try to get it right, so why not do so?

>>>> We have to be engaged in the process and figure out how to update the spec for what is
>>>> now the state of the art in the industry.
>>>> 
>>> 
>>> Again, not against that if it is necessary. For example your overlay stuff might
>>> be a good update to the spec. Would be better if it is official instead of a "hack".
>>> I want that for SoCFPGA.
>>> 
>>> But having looked at one or two vendor kernels+DTs, the state of the art in the
>>> industry is: using DT wrong. (And doing HW wrong, which makes some updates to the
>>> ePAPR necessary ;-))
>>> 
>> 
>> Vendor H/W, vendor DT and a crack pipe. Or as I call it Monday.
>> 
> 
> ;-)
> 
> Regards,
> Steffen
> 

Regards

— Pantelis

> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

