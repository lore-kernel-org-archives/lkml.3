Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3KZAxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:53:05 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3187 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752Ab3KZAxC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:53:02 -0500
From: =?iso-8859-1?Q?=22Andersson=2C_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 26 Nov 2013 01:52:59 +0100
Subject: Re: [PATCH 3/3] pinctrl: Add documentation for pinctrl-msm8x74
Thread-Topic: [PATCH 3/3] pinctrl: Add documentation for pinctrl-msm8x74
Thread-Index: Ac7qQdoFuBY5LjeKQkOzPn4vITHYpw==
Message-ID: <CEB92A62.3A401%bjorn.andersson@sonymobile.com>
In-Reply-To: <5293E7FB.6040300@wwwdotorg.org>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.0.121105
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/25/13 4:14 PM, "Stephen Warren" <swarren@wwwdotorg.org> wrote:

>On 11/23/2013 04:38 PM, Bjorn Andersson wrote:
>> This adds initial documentation for the pinctrl-msm8x74 driver.
>
>> diff --git 
>>a/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
>>b/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
>
>> +Qualcomm MSM8x74 TLMM block
>> +
>> +Required properties:
>> +- compatible: "qcom,msm8x74-pinctrl"
>> +- reg: Should be the base address of the TLMM block.
>
>base address *and length*?

Of course

>
>> +- interrupts: Should be the irq of the TLMM summary interrupt.
>
>s/irq/IRQ/

OK

>
>> +- interrupt-controller: Marks the device node as an interrupt
>>controller.
>> +- #interrupt-cells: Should be two.
>> +- gpio-controller: Marks the device node as a GPIO controller.
>> +- #gpio-cells : Should be two.
>> +                The first cell is the gpio pin number and the
>> +                second cell is used for optional parameters.
>> +
>> +Please refer to ../gpio/gpio.txt for a general description of GPIO
>>bindings.
>
>It's probably worth linking to ../interrupt-controller/interrupts.txt too.

Will do.

>
>> +Please refer to pinctrl-bindings.txt in this directory for details of
>>the
>> +common pinctrl bindings used by client devices, including the meaning
>>of the
>> +phrase "pin configuration node".
>> +
>> +Each subnode describes properties for the given pins.
>
>Which subnodes? It's probably worth describing what subnodes can exist.
>Perhaps try cribbing e.g. the 3 paragraphs in the Tegra binding that
>appear right after the "Please refer to pinctrl-bindings.txt..." that's
>there.

I see that most other documents have a variation of those paragraphs, so
I better follow that then.

>
>> +Required subnode-properties:
>> +- qcom,pins: An array of strings, each matching a pin or group to be
>> +             configured. Possible values are listed below.
>
>It isn't clear from this that these properties exist in a sub-sub-node,
>not just a sub-node, of the main pinctrl node.
>
>> +Optional subnode-properties:
>> +- qcom,function: A name of the function to be muxed to the specified
>> +                 pins. Possible values are listed below.
>
>Are "pins" and "functions" generic enough now that they don't need a
>vendor prefix? Both those property names are certainly mentioned in
>pinctrl-bindings.txt.

I've missed that these where in pinconf-generic. I based
msm_dt_subnode_to_map
on the tegra implementation and made changes to support pinconf-generic,
which
now seems identical with pinconf_generic_dt_subnode_to_map.
I'll use that directly instead.

>
>> +- drive-strength: Configure the drive strength of the specified pins.
>
>What units? I assume the definition matches that in
>pinctrl-bindings.txt? Perhaps it'd be simpler to say "The following
>generic properties as defined in pinctrl-bindings.txt: pins, function,
>bias-disable, ...".

Sounds much better than duplicating that information here.

>
>> +Valid values for qcom,function are:
>> +  blsp_i2c2, blsp_i2c6, blsp_i2c11, blsp_spi1, blsp_uart2, blsp_uart8,
>>slimbus
>> +
>> +  (Note that this is not yet the complete list of functions)
>
>It'd be best if the complete list were defined from the start. That
>said, I suppose adding new values into the list would be
>backwards-compatible (if not forwards-compatible i.e. new DTs usable
>with old kernels).

This list is enough for the currently supported (and published on
linux-arm-msm)
drivers for the 8x74 based DragonBoard. I wanted to get some feedback
before adding
more of the functions in the msm8x74 tables.

>
>> +Example:
>> +
>> +	msmgpio: pinctrl@fd510000 {
>...
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&uart2_default>;
>> +
>> +		uart2 {
>
>What does that node represent? Other pinctrl bindings  only have 1 or 2
>levels of subnodes, not 3.

I liked the concept of grouping related states/muxes together and then I
saw Linus'
ux500 series that did the same thing. But as it's just a matter of taste I
should
probably remove it from the example and just make sure it's clear above
that such
structure is okay.

>
>> +			uart2_default: uart2_default {
>> +				mux {
>> +					qcom,pins = "gpio4", "gpio5";
>> +					qcom,function = "blsp_uart2";
>> +				};

Thanks for your comments!

Regards,
Bjorn

