Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaJTJgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:36:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57708 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbaJTJgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:36:08 -0400
Date: Mon, 20 Oct 2014 10:35:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
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
Subject: Re: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi
 w2sg0004 gps
Message-ID: <20141020093536.GA25360@leverpostej>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com>
 <1413491183-15018-2-git-send-email-marek@goldelico.com>
 <20141017093714.GB4202@leverpostej>
 <D65FF64A-856F-47EC-B3DE-7F2FCE505087@goldelico.com>
 <20141017110043.GA5335@leverpostej>
 <27AD2801-6410-44E3-9E0C-911D73E6A457@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27AD2801-6410-44E3-9E0C-911D73E6A457@goldelico.com>
Thread-Topic: [PATCH 2/2] Documentation: devicetree: Add bindings for Wi2Wi
 w2sg0004 gps
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 17, 2014 at 08:55:50PM +0100, Dr. H. Nikolaus Schaller wrote:
> 
> Am 17.10.2014 um 13:00 schrieb Mark Rutland <mark.rutland@arm.com>:
> 
> > On Fri, Oct 17, 2014 at 11:16:42AM +0100, Dr. H. Nikolaus Schaller wrote:
> >> 
> >> Am 17.10.2014 um 11:37 schrieb Mark Rutland <mark.rutland@arm.com>:
> >> 
> >>> On Thu, Oct 16, 2014 at 09:26:23PM +0100, Marek Belisko wrote:
> >>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> >>>> Signed-off-by: Marek Belisko <marek@goldelico.com>
> >>>> ---
> >>>> .../devicetree/bindings/misc/wi2wi,w2sg0004.txt    | 44 ++++++++++++++++++++++
> >>>> 1 file changed, 44 insertions(+)
> >>>> create mode 100644 Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> >>>> 
> >>>> diff --git a/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> >>>> new file mode 100644
> >>>> index 0000000..e144441
> >>>> --- /dev/null
> >>>> +++ b/Documentation/devicetree/bindings/misc/wi2wi,w2sg0004.txt
> >>>> @@ -0,0 +1,44 @@
> >>>> +Wi2Wi GPS module connected through UART
> >>>> +
> >>>> +Required properties:
> >>>> +- compatible: wi2wi,w2sg0004 or wi2wi,w2sg0084
> >>>> +- pinctrl: specify two states (default and monitor). One is the default (UART) mode
> >>>> +  and the other is for monitoring the RX line by an interrupt
> >>>> +- on-off-gpio: the GPIO that controls the module's on-off toggle input
> >>>> +
> >>>> +Optional properties:
> >>>> +- lna-suppy: an (optional) LNA regulator that is enabled together with the GPS receiver
> >>>> +
> >>>> +example:
> >>>> +
> >>>> +        gps_receiver: w2sg0004 {
> >>>> +                compatible = "wi2wi,w2sg0004";
> >>> 
> >>> I couldn't spot "wi2wi" in
> >>> Documentation/devicetree/bindings/vendor-prefixes.txt (in mainline).
> >>> 
> >>> Could you please add it?
> >>> 
> >>>> +                gpio-controller;
> >>>> +                #gpio-cells = <2>;
> >>> 
> >>> As far as I can see, these properties aren't necessary. This only
> >>> consumes a GPIO, it doesn't provide any.
> >> 
> >> Well, it provides one GPIO. Sort of a "virtual“ GPIO. It is needed so that 
> >> it can be wired up to the DTR gpio of the UART driver (unfortunately this
> >> patch was reverted some months ago from mainline and we will reintroduce
> >> it soon).
> > 
> > If this GPIO doesn't really exist, then it's a Linux internal
> > implementation detail rather than a description of the hardware, and
> > doesn't really belong in the DT.
> 
> Hm. 
> 
> Let’s describe it differently.
> 
> I can see the Linux driver module as a simple software simulation for a
> piece of hardware that could have been connected between the UART
> and the GPS chip.
> 
> Basically it is a pulse-generator and a flip-flop to detect data flow on the RX
> wire. This could be implemented by an external FPGA or uController. Or as
> it is done on our board for saving hardware by a mix of the main CPU hardware
> (Pinmux + GPIO + IRQ) and a kernel driver.
> 
> The best of course would have been if the w2sg0004 would have a physical
> „enable“ GPIO (instead of that on-off control input).
> 
> Then we would hook up that enable to some physical GPIO of the CPU
> and simply refer to it as e.g. <&gpio4 12>. And would not even need a driver
> for it (unless we want to make rfkill gps work).
> 
> Therefore the driver we suggest provides an additional gpio controller with a
> single GPIO so that we can write <&w2sg 0> to refer to this virtual gpio.
> 
> So in fact we try to wrap a non-optimal chip design by the driver and make it
> appear as a standard GPIO interface to the DT and user space and whoever
> needs simply to enable/disable the GPS chip.

The fact remains that this does not accurately represent the hardware,
and is unnecessarily strongly tied to a particular UART design (where
the DTR line is a separate UART).

> > It sounds like what we actually need is the ability to describe devices
> > attached to UARTs.
> 
> Hm. The purpose of the driver is power control of the chip. Not the serial
> interface.

I'm not sure I follow your point. By describing the device as attached
to the UART, the kernel can figure out that when said UART is accessed
the attached device needs to be on (and must be poked as necessary).

The power management logic for the device can stay in the device driver,
and the power management logic for the UART can stay in the UART driver.
Neither would need to know about each other's internal details
(e.g.GPIOs, for DTR or otherwise).

> > Then you could have a mechanism whereby the UART
> > driver can notify the other device driver regarding events (e.g. the
> > UART being opened for access), or the other driver could claim ownership
> > of the UART and expose its own interface to userspace.
> > 
> > That would be independent of the particular UART or other device, and
> > the only description necessary in the DT would be an accurate
> > representation of the way the hardware is wired.
> > 
> > There are a few ways that could be done, but I suspect the simplest is
> > to just have the device as a sub-node of the UART, like we do for SPI or
> > I2C buses:
> > 
> > 	serial@f00 {
> > 		compatible = "vendor,uart";
> > 		reg = <0xf00 0x100>;
> > 		...
> > 
> > 		gps {
> > 			compatible = "wi2wi,w2sg0004";
> > 			...
> > 		};
> > 	};
> > 
> > That wouldn't work for devices with multiple UART connections. Do those
> > exist, and are they common in configurations where out-of-band
> > management is necessary (e.g. regulators, clocks)?
> 
> UARTs are usually point to point interfaces and not busses. So there is
> no need to describe the interface.

I don't follow. You have a device which seems to require management
kernel-side. Rather than describing the interface, you've described a
fictitious relationship between the GPS device and the UART's DTR GPIO,
and you've described a fictitious GPIO to hand to the UART driver. This
is how you have linked the two in order to get the behaviour you want.

So it _is_ necessary to describe the interface. Rather than describing
that interface at a high level you've chosen to hack together a set of
fake relationships to work around the lack of ability to describe said
interface.

> And I would speculate that in most cases they simply go to some
> connector and therefore no connected chip that needs to be described
> in the DT at all. Because it has a user-space driver (e.g. AT
> commands) and no kernel driver.

In the case where no driver is necessary I agree that no description is
necessary, though the description could be exposed in a helpful way to
userspace to describe what's attached to which UARTs.

However, in this case you do have a kernel driver (even if basic), and
it requires some knowledge of the relationship between the device and
the UART in order to function.

> But we have no idea how such a solution could be implemented or tested.

I would disagree on that point, given I provided a high level
description of how this could be implemented.

> If someone adds that to the serial drivers, we would be happy to use it,
> but unless such a thing exists, I think our solution is quite simple and isolated
> into this single driver and also uses existing standard interfaces (gpios, pinmux).

I would argue that this _abuses_ standard interfaces, as you have one
device driver fiddling with resources logically owned by another.

> >> The reason to solve it that way is that we did not want to have a direct link
> >> between this driver and any serial drivers or other mechanisms how drivers
> >> can detect that their serial port (/dev/tty*) is opened.
> >> 
> >> It is used to power down the w2sg GPS chip if no user space process is
> >> accessing its serial port (or de-asserts DTR through tcsetattr/ioctl).
> >> 
> >>> 
> >>>> +
> >>>> +                pinctrl-names = "default", "monitor";
> >>>> +                pinctrl-0 = <&uart2_pins>;
> >>>> +                pinctrl-1 = <&uart2_rx_irq_pins>;
> >>>> +
> >>>> +                interrupt-parent = <&gpio5>;
> >>>> +                interrupts = <19 IRQ_TYPE_EDGE_FALLING>;  /* GPIO_147: RX - trigger on arrival of start bit */
> >>> 
> >>> While interrupts is a standard property, please describe above how many
> >>> you expect and what their logical function is.
> >>> 
> >>> The only part I'm confused about is how the link to the UART is
> >>> described. I assume I'm just ignorant of some existing pattern.
> >> 
> >> The serial link itself is not described at all because it is assumed to be a „must have“.
> > 
> > Huh? So it's a "must have" that you "don't have" in the DT?
> 
> Yes. The DT does not describe everything. Only those things that need
> a kernel driver. And UARTs usually have user-space drivers (e.g. gpsd,
> gsmd, pppd) and ioctl/tcsetattr.

The DT should describe the static portions of the hardware. Typically we
only have devices with kernelspace drivers described simply because
that's the way people have built DTs. Whether or not you have a
kernelspace driver can change over time, the organisation of the
hardware cannot.

> > I think that the relationship is being described incorrectly in the DT,
> > and I think that there is a more general problem that needs to be
> > addressed in order to make this case work.
> > 
> >> The driver only needs to monitor the RX line and needs to switch it between UART and
> >> GPIO/IRQ mode. So this monitoring switch is described (with two different pinctrl states).
> > 
> > While this particular driver only needs that at this point in time,
> > that's not necessarily true of drivers for similar devices, nor is it
> > necessarily true if we need to add additional features to this driver.
> 
> Which features are you thinking of to add to this driver? And do
> similar devices exist at all? Since we have not found any, we have
> declared it as a "misc“ driver.

I don't have any particular feature in mind.

I am not immediately aware of other serial devices which require
out-of-band management in the same way, though we have a vaguely similar
case with SDIO devices which must be powered up before they appear on
the bus. In that case I believe the intent is to describe them in the DT
under the bus.

> > Describing the relationship leaves a lot more freedom to improve things
> > without having to update every DTB.
> > 
> >> We know that it is a little tricky to control this chip correctly - and we think this solution
> >> is the most general (no direct dependency on the serial line, and just to pinmux states
> >> and an interrupt).
> > 
> > I think that the rough approach I sketched out above is more general,
> > and I think that you must describe the relationship with the serial
> > line.
> > 
> > It's not clear to me whether the interrupt you describe is attached to
> > the GPS, or if this is logically part of the UART.
> 
> The interrupt is needed to simulate the glue logic connected between
> UART and GPS.
> 
> The output signal comes from the GPS module and goes to some pad
> of the OMAP3 SoC. This pad can be either multiplexed into the UART RX
> input or into a GPIO bank of the OMAP. That GPIO controller can generate
> the interrupt on incoming data (when none is expected).
> 
> Therefore it is a GPS-generated interrupt and has nothing to do with
> the UART.

Ok. When does the GPS device raise this interrupt?

Thanks,
Mark.
