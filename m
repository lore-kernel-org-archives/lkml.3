Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaJTR1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:27:03 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:59923 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaJTR05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:26:57 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat/htPqw40=
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi w2sg0004 gps
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20141020093536.GA25360@leverpostej>
Date: Mon, 20 Oct 2014 19:26:27 +0200
Cc: Marek Belisko <marek@goldelico.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <7A9F8C73-6CBD-435A-934C-14A80FFE452F@goldelico.com>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com> <1413491183-15018-2-git-send-email-marek@goldelico.com> <20141017093714.GB4202@leverpostej> <D65FF64A-856F-47EC-B3DE-7F2FCE505087@goldelico.com> <20141017110043.GA5335@leverpostej> <27AD2801-6410-44E3-9E0C-911D73E6A457@goldelico.com> <20141020093536.GA25360@leverpostej>
To: Mark Rutland <mark.rutland@arm.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 20.10.2014 um 11:35 schrieb Mark Rutland <mark.rutland@arm.com>:

> Hi,
> 
> On Fri, Oct 17, 2014 at 08:55:50PM +0100, Dr. H. Nikolaus Schaller wrote:
>> 
>> Am 17.10.2014 um 13:00 schrieb Mark Rutland <mark.rutland@arm.com>:
>> 
>>> On Fri, Oct 17, 2014 at 11:16:42AM +0100, Dr. H. Nikolaus Schaller wrote:
>>>> 
>>>> Am 17.10.2014 um 11:37 schrieb Mark Rutland <mark.rutland@arm.com>:
>>>> 
>>>>> On Thu, Oct 16, 2014 at 09:26:23PM +0100, Marek Belisko wrote:
>>>>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>>>>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>>>>>> ---
>>>>>> .../devicetree/bindings/misc/wi2wi,w2sg0004.txt    | 44 ++++++++++++++++++++++
>>>>>> 1 file changed, 44 insertions(+)
>>>>>> create mode 100644 Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
>>>>>> 
>>>>>> diff --git a/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
>>>>>> new file mode 100644
>>>>>> index 0000000..e144441
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
>>>>>> @@ -0,0 +1,44 @@
>>>>>> +Wi2Wi GPS module connected through UART
>>>>>> +
>>>>>> +Required properties:
>>>>>> +- compatible: wi2wi,w2sg0004 or wi2wi,w2sg0084
>>>>>> +- pinctrl: specify two states (default and monitor). One is the default (UART) mode
>>>>>> +  and the other is for monitoring the RX line by an interrupt
>>>>>> +- on-off-gpio: the GPIO that controls the module's on-off toggle input
>>>>>> +
>>>>>> +Optional properties:
>>>>>> +- lna-suppy: an (optional) LNA regulator that is enabled together with the GPS receiver
>>>>>> +
>>>>>> +example:
>>>>>> +
>>>>>> +        gps_receiver: w2sg0004 {
>>>>>> +                compatible = "wi2wi,w2sg0004";
>>>>> 
>>>>> I couldn't spot "wi2wi" in
>>>>> Documentation/devicetree/bindings/vendor-prefixes.txt (in mainline).
>>>>> 
>>>>> Could you please add it?
>>>>> 
>>>>>> +                gpio-controller;
>>>>>> +                #gpio-cells = <2>;
>>>>> 
>>>>> As far as I can see, these properties aren't necessary. This only
>>>>> consumes a GPIO, it doesn't provide any.
>>>> 
>>>> Well, it provides one GPIO. Sort of a "virtual“ GPIO. It is needed so that 
>>>> it can be wired up to the DTR gpio of the UART driver (unfortunately this
>>>> patch was reverted some months ago from mainline and we will reintroduce
>>>> it soon).
>>> 
>>> If this GPIO doesn't really exist, then it's a Linux internal
>>> implementation detail rather than a description of the hardware, and
>>> doesn't really belong in the DT.
>> 
>> Hm. 
>> 
>> Let’s describe it differently.
>> 
>> I can see the Linux driver module as a simple software simulation for a
>> piece of hardware that could have been connected between the UART
>> and the GPS chip.
>> 
>> Basically it is a pulse-generator and a flip-flop to detect data flow on the RX
>> wire. This could be implemented by an external FPGA or uController. Or as
>> it is done on our board for saving hardware by a mix of the main CPU hardware
>> (Pinmux + GPIO + IRQ) and a kernel driver.
>> 
>> The best of course would have been if the w2sg0004 would have a physical
>> „enable“ GPIO (instead of that on-off control input).
>> 
>> Then we would hook up that enable to some physical GPIO of the CPU
>> and simply refer to it as e.g. <&gpio4 12>. And would not even need a driver
>> for it (unless we want to make rfkill gps work).
>> 
>> Therefore the driver we suggest provides an additional gpio controller with a
>> single GPIO so that we can write <&w2sg 0> to refer to this virtual gpio.
>> 
>> So in fact we try to wrap a non-optimal chip design by the driver and make it
>> appear as a standard GPIO interface to the DT and user space and whoever
>> needs simply to enable/disable the GPS chip.
> 
> The fact remains that this does not accurately represent the hardware,
> and is unnecessarily strongly tied to a particular UART design (where
> the DTR line is a separate UART).

I don’t get that it is tied to a particular UART design (except that our DTR
patch affects to omap-serial only).

Let’s describe the facts:

The chip has this interface:

GPS-TX (output)
GPS-RX (input)
ON/OFF (input) - to toggle the power state of the chip

They are connected to an OMAP3 UART2 as

UART2-TX > GPS-RX
UART2-RX <- GPS-TX
GPIO145 -> ON/OFF

That’s it.

If the chip (or any other serial GPS receiver like a Garmin) were connected
through real RS232 we would have

UART2-TX -> level shifter -> cable -> level shifter -> GPS-RX
UART2-RX <- level shifter <- cable <- level shifter <- GPS-TX
DTR-GPIO -> level shifter (DTR line) -> cable -> level shifter -> power-management logic -> ON/OFF

But because it is connected directly, we need to implement the power-management
logic between the DTR-GPIO and GPIO145:

DTR-GPIO -> driver -> GPIO145 -> ON/OFF

To correctly determine the state we need to tap the RX signal before
it enters the UART2-RX (it is pinmuxed with GPIO147):

UART2-RX <——+
                               OMAP3 pinmux <- OMAP3 pad <- GPS-TX
   GPIO147 <——+

So if we describe the driver as a box we have

inputs from user space:
* rfkill for GPS
* a control that is activated by opening /dev/tty

outputs to system:
* a control to switch the pinmux between RX and GPIO (interrupt)
* a control to external hardware

> 
>>> It sounds like what we actually need is the ability to describe devices
>>> attached to UARTs.
>> 
>> Hm. The purpose of the driver is power control of the chip. Not the serial
>> interface.
> 
> I'm not sure I follow your point. By describing the device as attached
> to the UART, the kernel can figure out that when said UART is accessed
> the attached device needs to be on (and must be poked as necessary).

Why do we need to describe this? It is all about controlling the GPIO145,
GPIO147 and pinmux. But not RX or TX.

So the driver does not need to know anything about UARTs (and if we
connect it to UART3 we only have to specify different GPIOs).

Only our board specific dtb connects the UART to the “virtual” GPIO
provided by the driver.

This also brings up a minor problem: on OMAP3 some UART RX lines can
be pinmuxed with different GPIOs. So putting the driver under some UART2
node doesn’t uniquely define the GPIO number to monitor RX and might
become a mess.

> 
> The power management logic for the device can stay in the device driver,
> and the power management logic for the UART can stay in the UART driver.

Here I can’t follow you. What power management does an UART driver provide?

> Neither would need to know about each other's internal details
> (e.g.GPIOs, for DTR or otherwise).

Yes, that is our goal and in our solution they don’t need to make assumptions
about each other. We just define in the DT: this GTA04 board has UART2-DTR
connected to the W2SG-GPIO# - instead of OMAP3-GPIO145.

In our solution the UART driver knows that there could be a DTR GPIO (similar to
a RTS GPIO which is already provided by the omap-serial RS484 bindings). Which
could be connected to some GPIO which drives the real DTR wire of a RS232 level
shifter.

> 
>>> Then you could have a mechanism whereby the UART
>>> driver can notify the other device driver regarding events (e.g. the
>>> UART being opened for access), or the other driver could claim ownership
>>> of the UART and expose its own interface to userspace.
>>> 
>>> That would be independent of the particular UART or other device, and
>>> the only description necessary in the DT would be an accurate
>>> representation of the way the hardware is wired.
>>> 
>>> There are a few ways that could be done, but I suspect the simplest is
>>> to just have the device as a sub-node of the UART, like we do for SPI or
>>> I2C buses:
>>> 
>>> 	serial@f00 {
>>> 		compatible = "vendor,uart";
>>> 		reg = <0xf00 0x100>;
>>> 		...
>>> 
>>> 		gps {
>>> 			compatible = "wi2wi,w2sg0004";
>>> 			...
>>> 		};
>>> 	};
>>> 
>>> That wouldn't work for devices with multiple UART connections. Do those
>>> exist, and are they common in configurations where out-of-band
>>> management is necessary (e.g. regulators, clocks)?
>> 
>> UARTs are usually point to point interfaces and not busses. So there is
>> no need to describe the interface.
> 
> I don't follow. You have a device which seems to require management
> kernel-side.

Yes, power on/off.

> Rather than describing the interface, you've described a
> fictitious relationship between the GPS device and the UART's DTR GPIO,
> and you’ve described a fictitious GPIO to hand to the UART driver.

Yes. Because the UART driver would generally expect a GPIO (if a GPIO driven
DTR hardware line is available on the connector).

> This
> is how you have linked the two in order to get the behaviour you want.

Exactly.

> 
> So it _is_ necessary to describe the interface. Rather than describing
> that interface at a high level you've chosen to hack together a set of
> fake relationships to work around the lack of ability to describe said
> interface.

The power control interface is a single GPIO from UART to the driver.
The other end is an interface from the driver to the pinmux of the OMAP
and the chip. So it is a “middleman”. But I think this is already clear.

> 
>> And I would speculate that in most cases they simply go to some
>> connector and therefore no connected chip that needs to be described
>> in the DT at all. Because it has a user-space driver (e.g. AT
>> commands) and no kernel driver.
> 
> In the case where no driver is necessary I agree that no description is
> necessary, though the description could be exposed in a helpful way to
> userspace to describe what’s attached to which UARTs.

That is usually done by configuring the gpsd process.

> 
> However, in this case you do have a kernel driver (even if basic), and
> it requires some knowledge of the relationship between the device and
> the UART in order to function.

Yes. And that is what we want to provide by the dtb file. That one should describe
the relationship.

> 
>> But we have no idea how such a solution could be implemented or tested.
> 
> I would disagree on that point, given I provided a high level
> description of how this could be implemented.

We do understand how you suggest the bindings should look like, but we have
no idea how that translates into code.

And we do not want to touch the general serial drivers, just the omap-serial
(because the solutions does not work without an UART behind a pinmux with a
GPIO with interrupt capabilities).

We simply have no experience modifying serial drivers (Linux is too big that anyone
can know all areas).

Our experience is limited to re-submitting the DTR-GPIO-control patch by Neil Brown
and making it read DT properties instead of board file.

So your approach needs a lot of help to really implement it. The question is who
will be doing it.

> 
>> If someone adds that to the serial drivers, we would be happy to use it,
>> but unless such a thing exists, I think our solution is quite simple and isolated
>> into this single driver and also uses existing standard interfaces (gpios, pinmux).
> 
> I would argue that this _abuses_ standard interfaces, as you have one
> device driver fiddling with resources logically owned by another.
> 
>>>> The reason to solve it that way is that we did not want to have a direct link
>>>> between this driver and any serial drivers or other mechanisms how drivers
>>>> can detect that their serial port (/dev/tty*) is opened.
>>>> 
>>>> It is used to power down the w2sg GPS chip if no user space process is
>>>> accessing its serial port (or de-asserts DTR through tcsetattr/ioctl).
>>>> 
>>>>> 
>>>>>> +
>>>>>> +                pinctrl-names = "default", "monitor";
>>>>>> +                pinctrl-0 = <&uart2_pins>;
>>>>>> +                pinctrl-1 = <&uart2_rx_irq_pins>;
>>>>>> +
>>>>>> +                interrupt-parent = <&gpio5>;
>>>>>> +                interrupts = <19 IRQ_TYPE_EDGE_FALLING>;  /* GPIO_147: RX - trigger on arrival of start bit */
>>>>> 
>>>>> While interrupts is a standard property, please describe above how many
>>>>> you expect and what their logical function is.
>>>>> 
>>>>> The only part I'm confused about is how the link to the UART is
>>>>> described. I assume I'm just ignorant of some existing pattern.
>>>> 
>>>> The serial link itself is not described at all because it is assumed to be a „must have“.
>>> 
>>> Huh? So it's a "must have" that you "don't have" in the DT?
>> 
>> Yes. The DT does not describe everything. Only those things that need
>> a kernel driver. And UARTs usually have user-space drivers (e.g. gpsd,
>> gsmd, pppd) and ioctl/tcsetattr.
> 
> The DT should describe the static portions of the hardware. Typically we
> only have devices with kernelspace drivers described simply because
> that's the way people have built DTs. Whether or not you have a
> kernelspace driver can change over time, the organisation of the
> hardware cannot.

So far none of the DT I have seen describe what is connected to the UART.
Even for boards which use HCI to communicate with a Bluetooth module.

> 
>>> I think that the relationship is being described incorrectly in the DT,
>>> and I think that there is a more general problem that needs to be
>>> addressed in order to make this case work.
>>> 
>>>> The driver only needs to monitor the RX line and needs to switch it between UART and
>>>> GPIO/IRQ mode. So this monitoring switch is described (with two different pinctrl states).
>>> 
>>> While this particular driver only needs that at this point in time,
>>> that's not necessarily true of drivers for similar devices, nor is it
>>> necessarily true if we need to add additional features to this driver.
>> 
>> Which features are you thinking of to add to this driver? And do
>> similar devices exist at all? Since we have not found any, we have
>> declared it as a "misc“ driver.
> 
> I don't have any particular feature in mind.
> 
> I am not immediately aware of other serial devices which require
> out-of-band management in the same way, though we have a vaguely similar
> case with SDIO devices which must be powered up before they appear on
> the bus.

AFAIK, they are usually descibed by a regulator that is enabled/disabled by
the SDIO driver. And the regulator is usually defined as a gpio-regulator to
drive an GPIO.

And I think the SDIO driver has a reset-gpio (which can also be interpreted
as a disable/power-down).

So such interface drivers simply expect that they can power-control dependent
devices through a regulator or a simple gpio.

> In that case I believe the intent is to describe them in the DT
> under the bus.

Or would it be ok to allow a regulator property for the serial interface? Then
our driver would become a w2sg0004-regulator driver similar to a gpio-regulator
but with a state machine that knows how to pulse the gpio until power is applied
to the GPS receiver internals.

> 
>>> Describing the relationship leaves a lot more freedom to improve things
>>> without having to update every DTB.
>>> 
>>>> We know that it is a little tricky to control this chip correctly - and we think this solution
>>>> is the most general (no direct dependency on the serial line, and just to pinmux states
>>>> and an interrupt).
>>> 
>>> I think that the rough approach I sketched out above is more general,
>>> and I think that you must describe the relationship with the serial
>>> line.
>>> 
>>> It's not clear to me whether the interrupt you describe is attached to
>>> the GPS, or if this is logically part of the UART.
>> 
>> The interrupt is needed to simulate the glue logic connected between
>> UART and GPS.
>> 
>> The output signal comes from the GPS module and goes to some pad
>> of the OMAP3 SoC. This pad can be either multiplexed into the UART RX
>> input or into a GPIO bank of the OMAP. That GPIO controller can generate
>> the interrupt on incoming data (when none is expected).
>> 
>> Therefore it is a GPS-generated interrupt and has nothing to do with
>> the UART.
> 
> Ok. When does the GPS device raise this interrupt?

If the driver assumes the GPS receiver is turned off, it disconnedts the RX
wire from the UART to a GPIO by using two different pinmux states.

If the GPIO raises an interrupt, the driver knows that the GPS module is not
turned off, because the driver has lost knowledge about its state. This is not
an UART related function but OMAP pinmux and GPIO.

I am not sure if that could even be implemented at all by a UART dependent
driver (since the UART is shut down and does not interrupt).

> 
> Thanks,
> Mark.

Thanks as well - it is a fruitful discussion (even if it becomes lengthy because
I might have repeated a lot of things that are already clear. Please accept an apology).

I think we just disagree about implementing a version that “works” in a quite specific
setup (there are necessary assumptions about OMAP pinmux and omap-serial) with
existing APIs versus a general one that might need a lot of changes outside the driver
and introduce new APIs.

BR,
Nikolaus

