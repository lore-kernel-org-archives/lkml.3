Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab3FDGf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:35:28 -0400
Received: from www.xora.org.uk ([80.68.91.202]:47446 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FDGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:35:24 -0400
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Jun 2013 02:35:24 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Jun 2013 07:24:36 +0100
From: gg@slimlogic.co.uk
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, sfr@canb.auug.org.au, rpurdie@rpsys.net,
        akpm@linux-foundation.org, sameo@linux.intel.com, wim@iguana.be,
        lgirdwood@gmail.com, ldewangan@nvidia.com,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: RE: [PATCH v10 01/12] mfd: DT bindings for the palmas family MFD
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229E662E@DBDE04.ent.ti.com>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
 <1363964122-19201-2-git-send-email-ian@slimlogic.co.uk>
 <5150906F.9040202@wwwdotorg.org> <51A73908.7020206@ti.com>
 <51A7DAC2.80602@wwwdotorg.org>
 <DC88CAD03C0052499C1907B327FC63229E662E@DBDE04.ent.ti.com>
Message-ID: <6af100d1d4ba82de24f96561b5108072@slimlogic.co.uk>
User-Agent: Roundcube Webmail/0.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-03 07:55, J, KEERTHY wrote:
> Hi Stephen,
> 
>> -----Original Message-----
>> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
>> Sent: Friday, May 31, 2013 4:34 AM
>> To: J, KEERTHY
>> Cc: gg@slimlogic.co.uk; Ian Lartey; linux-kernel@vger.kernel.org;
>> linux-doc@vger.kernel.org; linux-arm-kernel@lists.infradead.org; 
>> linux-
>> leds@vger.kernel.org; linux-watchdog@vger.kernel.org; devicetree-
>> discuss@lists.ozlabs.org; grant.likely@secretlab.ca;
>> broonie@opensource.wolfsonmicro.com; rob.herring@calxeda.com;
>> rob@landley.net; mturquette@linaro.org; linus.walleij@linaro.org;
>> cooloney@gmail.com; sfr@canb.auug.org.au; rpurdie@rpsys.net;
>> akpm@linux-foundation.org; sameo@linux.intel.com; wim@iguana.be;
>> lgirdwood@gmail.com; ldewangan@nvidia.com; Kristo, Tero
>> Subject: Re: [PATCH v10 01/12] mfd: DT bindings for the palmas family
>> MFD
>> 
>> On 05/30/2013 05:33 AM, keerthy wrote:
>> >
>> > On 03/25/2013 11:29 PM, Stephen Warren wrote:
>> >
>> >> On 03/22/2013 08:55 AM, Ian Lartey wrote:
>> >>> From: Graeme Gregory <gg@slimlogic.co.uk>
>> >>>
>> >>> Add the various binding files for the palmas family of chips. There
>> >>> is a top level MFD binding then a seperate binding for IP blocks on
>> chips.
>> >>
>> >>> diff --git a/Documentation/devicetree/bindings/clock/palmas-clk.txt
>> >>> b/Documentation/devicetree/bindings/clock/palmas-clk.txt
>> >>
>> >> Where is the reg property; if you're instantiating the clk device as
>> >> a standalone DT node and driver, it should be possible to retrieve
>> >> the address of this IP block instance from DT, not using driver-
>> internal APIs.
>> >>
>> >> This same comment likely applies everywhere, so I won't repeat it.
>> >>
>> >>> +Example:
>> >>> +
>> >>> +clk {
>> >>> +    compatible = "ti,twl6035-clk", "ti,palmas-clk";
>> >>> +    ti,clk32kg-mode-sleep = <0>;
>> >>> +    ti,clk32kgaudio-mode-sleep = <0>;
>> >>
>> >>> +    #clock-cells = <1>;
>> >>> +    clock-frequency = <32000000>;
>> >>> +    clock-names = "clk32kg", "clk32kgaudio";
>> >>
>> >> The binding description itself should describe what clocks this node
>> >> provides and consumes.
>> >>
>> >> What is clock-frequency; which clock does it affect?
>> >>
>> >> The presence of #clock-cells implies this is a clock provider. This
>> >> binding should define the format of the clock cells that this
>> >> property implies. I assume it's just the ID of the output clocks,
>> but
>> >> what values correspond to which output clocks? That mapping table
>> >> needs to be listed here.
>> >>
>> >> The presence of clock-names implies this is a clock consumer.
>> >> However, there is no clocks property in the example. Is clks missing
>> >> from the example, or should this property be clock-output-names
>> >> instead? If this node is a clock consumer, the list of which clocks
>> >> it requires should be documented.
>> >>
>> >>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-palmas.txt
>> >>> b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt
>> >>
>> >>> +- gpio-controller: mark the device as a GPIO controller
>> >>> +- gpio-cells = <1>:  GPIO lines are provided.
>> >>
>> >> That's #gpio-cells not gpio-cells.
>> >>
>> >> I assume that cell simply contains the GPIO ID/number. That should
>> be
>> >> documented for clarity.
>> >>
>> >> Surely gpio-cells should be 2 not 1, so there is space for flags. At
>> >> least an "inverted" or "active-low" flag should be included; GPIO
>> >> consumers would typically implement that flag in SW, so there' no
>> >> requirement that the flag only be supported if the HW supports the
>> feature.
>> >>
>> >>> +- interrupt-controller : palmas has its own internal IRQs
>> >>> +- #interrupt-cells : should be set to 2 for IRQ number and flags
>> >>> +  The first cell is the IRQ number.
>> >>> +  The second cell is the flags, encoded as the trigger masks from
>> >>> +  Documentation/devicetree/bindings/interrupts.txt
>> >>
>> >> You need "/interrupt-controller" before the filename there.
>> >>
>> >>> +- interrupt-parent : The parent interrupt controller.
>> >>
>> >> If this IP block has interrupt outputs, it should require an
>> >> "interrupts" property too. This is the same concept that drives the
>> >> need for a reg property. This same comment likely applies
>> everywhere,
>> >> so I won't repeat it.
>> >>
>> >>> diff --git
>> >>> a/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
>> >>> b/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
>> >>
>> >>> +- interrupts: the interrupt outputs of the controller.
>> >>
>> >> How many entries are there, what do they mean, and in what order
>> must
>> >> they appear? (Note that the binding of a node must define the order
>> >> of the interrupts property, since historically it's been accessed by
>> >> index, not by name, and all bindings must allow that access method
>> to be used).
>> >>
>> >>> +- interrupt-names : Should be the name of irq resource. Each
>> >>> +interrupt
>> >>> +  binds its interrupt-name.
>> >>
>> >> The binding needs to define standard names for the entries in this
>> >> property, or define that interrupts are only retrieved by index, in
>> >> which case interrupt-names shouldn't be present. This same comment
>> >> likely applies everywhere, so I won't repeat it.
>> >>
>> >>> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt
>> >>> b/Documentation/devicetree/bindings/mfd/palmas.txt
>> >>
>> >>> +Required properties:
>> >> ...
>> >>
>> >> I believe the Palmas devices have many separate I2C addresses, even
>> >> buses, which are I think are at least partially independently SW
>> >> configurable. In that case, the reg property for this node should
>> >> probably enumerate all the I2C addresses that this chip responds to,
>> >> so that they can each be passed down to the child nodes.
>> >
>> >
>> > Stephen,
>> >
>> > The palmas devices do have multiple I2C slave IDs. From OMAP5 as the
>> > master all the palmas slave devices are connected via I2C1 bus.
>> >
>> > I did not understand the SW configurable part. It is more board
>> > dependent. Correct me if i understood it wrongly.
>> 
>> IIRC (and I may not sine it's been a while since I looked at this),
>> there are SW registers that can modify the I2C address that the chip
>> will respond to, so you could access the main I2C address, then 
>> program
>> which other I2C addresses get used.
> 
> Ok. I guess you are referring to the I2C_SPI register of Palmas.
> This register is indeed SW configurable and I tried changing the
> Slave IDs on the fly and I could change them. AFAIK these are OTP
> And never changed through software on the fly.
> 
>> 
>> Or, perhaps I was just thinking of the fact that there are strapping
>> pins on the chip that affect both the main I2C address, and some/all 
>> of
>> the other I2C addresses, so the driver needs to be told each and every
>> I2C address, not just one single overall I2C address.
> 
> Looking at the register spec there seem to be 2 possible combinations:
> 0x48, 0x49, 0x4A or 0x58, 0x59, 0x5A. Again these are OTP. By default
> It is 0x48, 0x49, 0x4A. So passing 0x48 or 0x58 as the main I2C
> Address seems sufficient here.
> 
The I2C addresses are set in OTP, I do not think they should ever be 
changed
on the fly.

Graeme

