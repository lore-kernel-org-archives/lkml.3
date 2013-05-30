Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555Ab3E3Lfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:35:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54641 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3E3Lfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:35:34 -0400
Message-ID: <51A73908.7020206@ti.com>
Date: Thu, 30 May 2013 17:03:28 +0530
From: keerthy <j-keerthy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, <gg@slimlogic.co.uk>
CC: Ian Lartey <ian@slimlogic.co.uk>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-leds@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <broonie@opensource.wolfsonmicro.com>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <mturquette@linaro.org>, <linus.walleij@linaro.org>,
        <cooloney@gmail.com>, <sfr@canb.auug.org.au>, <rpurdie@rpsys.net>,
        <akpm@linux-foundation.org>, <sameo@linux.intel.com>, <wim@iguana.be>,
        <lgirdwood@gmail.com>, <ldewangan@nvidia.com>, <t-kristo@ti.com>
Subject: Re: [PATCH v10 01/12] mfd: DT bindings for the palmas family MFD
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk> <1363964122-19201-2-git-send-email-ian@slimlogic.co.uk> <5150906F.9040202@wwwdotorg.org>
In-Reply-To: <5150906F.9040202@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/25/2013 11:29 PM, Stephen Warren wrote:

> On 03/22/2013 08:55 AM, Ian Lartey wrote:
>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>
>> Add the various binding files for the palmas family of chips. There is a
>> top level MFD binding then a seperate binding for IP blocks on chips.
> 
>> diff --git a/Documentation/devicetree/bindings/clock/palmas-clk.txt b/Documentation/devicetree/bindings/clock/palmas-clk.txt
> 
> Where is the reg property; if you're instantiating the clk device as a
> standalone DT node and driver, it should be possible to retrieve the
> address of this IP block instance from DT, not using driver-internal APIs.
> 
> This same comment likely applies everywhere, so I won't repeat it.
> 
>> +Example:
>> +
>> +clk {
>> +    compatible = "ti,twl6035-clk", "ti,palmas-clk";
>> +    ti,clk32kg-mode-sleep = <0>;
>> +    ti,clk32kgaudio-mode-sleep = <0>;
> 
>> +    #clock-cells = <1>;
>> +    clock-frequency = <32000000>;
>> +    clock-names = "clk32kg", "clk32kgaudio";
> 
> The binding description itself should describe what clocks this node
> provides and consumes.
> 
> What is clock-frequency; which clock does it affect?
> 
> The presence of #clock-cells implies this is a clock provider. This
> binding should define the format of the clock cells that this property
> implies. I assume it's just the ID of the output clocks, but what values
> correspond to which output clocks? That mapping table needs to be listed
> here.
> 
> The presence of clock-names implies this is a clock consumer. However,
> there is no clocks property in the example. Is clks missing from the
> example, or should this property be clock-output-names instead? If this
> node is a clock consumer, the list of which clocks it requires should be
> documented.
> 
>> diff --git a/Documentation/devicetree/bindings/gpio/gpio-palmas.txt b/Documentation/devicetree/bindings/gpio/gpio-palmas.txt
> 
>> +- gpio-controller: mark the device as a GPIO controller
>> +- gpio-cells = <1>:  GPIO lines are provided.
> 
> That's #gpio-cells not gpio-cells.
> 
> I assume that cell simply contains the GPIO ID/number. That should be
> documented for clarity.
> 
> Surely gpio-cells should be 2 not 1, so there is space for flags. At
> least an "inverted" or "active-low" flag should be included; GPIO
> consumers would typically implement that flag in SW, so there' no
> requirement that the flag only be supported if the HW supports the feature.
> 
>> +- interrupt-controller : palmas has its own internal IRQs
>> +- #interrupt-cells : should be set to 2 for IRQ number and flags
>> +  The first cell is the IRQ number.
>> +  The second cell is the flags, encoded as the trigger masks from
>> +  Documentation/devicetree/bindings/interrupts.txt
> 
> You need "/interrupt-controller" before the filename there.
> 
>> +- interrupt-parent : The parent interrupt controller.
> 
> If this IP block has interrupt outputs, it should require an
> "interrupts" property too. This is the same concept that drives the need
> for a reg property. This same comment likely applies everywhere, so I
> won't repeat it.
> 
>> diff --git a/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt b/Documentation/devicetree/bindings/input/palmas-pwrbutton.txt
> 
>> +- interrupts: the interrupt outputs of the controller.
> 
> How many entries are there, what do they mean, and in what order must
> they appear? (Note that the binding of a node must define the order of
> the interrupts property, since historically it's been accessed by index,
> not by name, and all bindings must allow that access method to be used).
> 
>> +- interrupt-names : Should be the name of irq resource. Each interrupt
>> +  binds its interrupt-name.
> 
> The binding needs to define standard names for the entries in this
> property, or define that interrupts are only retrieved by index, in
> which case interrupt-names shouldn't be present. This same comment
> likely applies everywhere, so I won't repeat it.
> 
>> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documentation/devicetree/bindings/mfd/palmas.txt
> 
>> +Required properties:
> ...
> 
> I believe the Palmas devices have many separate I2C addresses, even
> buses, which are I think are at least partially independently SW
> configurable. In that case, the reg property for this node should
> probably enumerate all the I2C addresses that this chip responds to, so
> that they can each be passed down to the child nodes.


Stephen,

The palmas devices do have multiple I2C slave IDs. From OMAP5 as the master
all the palmas slave devices are connected via I2C1 bus.

I did not understand the SW configurable part. It is more board
dependent. Correct me if i understood it wrongly.

Graeme,

Can i send a separate Documentation patch for palmas-core and palmas-regulators
outside this series since the drivers are already part of mainline kernel.
This will ensure at least the bare minimal DT support for palmas family
will be available in the mainline kernel?

> 

>> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> 
>> +Optional nodes:
>> +- regulators : should contain the constrains and init information for the
>> +	       regulators. It should contain a subnode per regulator from the
>> +	       list.
>> +	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
>> +	       smps45, smps457, smps7 depending on varient, smps6, smps[8-10],
>> +	       ldo[1-9], ldoln, ldousb
>> +	       For ti,palmas-charger-pmic - smps12, smps123, smps3 depending on OTP,
>> +	       smps[6-9], boost, ldo[1-14], ldoln, ldousb
> 
> The list of legal compatible values for this node above doesn't include
> both ti,palmas-pmic and ti,palmas-charger-pmic. Should it? This node
> should describe this PMIC block in a completely standalone fashion,
> without the need to go look at the top-level node to see if it's a
> "charger" variant or not.
> 
>> +	       optional chip specific regulator fields :-
>> +	       ti,warm-reset - maintain voltage during warm reset
>> +	       ti,roof-floor - control voltage selection by pin
> 
> I assume those are Boolean not integer. It's worth mentioning the type
> of each property.




Reagrds,
Keerthy
