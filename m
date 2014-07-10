Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaGJJxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:53:34 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43799 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaGJJxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAJAp7OghZoTXutxw7hAsq1XA_wAhOXDNFO0tz8u9ceQ1fD9W1w@mail.gmail.com>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1404782785-1824-3-git-send-email-bjorn.andersson@sonymobile.com>
	<CACRpkdZ2hekBGe1-9GV-amqi50heghWhXJ9raW7P_Nif_Ci88g@mail.gmail.com>
	<CAJAp7OghZoTXutxw7hAsq1XA_wAhOXDNFO0tz8u9ceQ1fD9W1w@mail.gmail.com>
Date: Thu, 10 Jul 2014 11:53:30 +0200
Message-ID: <CACRpkdai=q3nmPk5OWQWn_UMdXmqcbFXJ90rxREBG9k6gdy88Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: Device tree bindings for Qualcomm pm8xxx
 gpio block
From: Linus Walleij <linus.walleij@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>, Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 11:18 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Wed, Jul 9, 2014 at 1:53 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Tue, Jul 8, 2014 at 3:26 AM, Bjorn Andersson
>> <bjorn.andersson@sonymobile.com> wrote:

>>> +The following generic properties as defined in pinctrl-bindings.txt are valid
>>> +to specify in a pin configuration subnode:
>>> +
>>> +- pins:
>>> +       Usage: required
>>> +       Value type: <string-array>
>>> +       Definition: List of gpio pins affected by the properties specified in
>>> +                   this subnode.  Valid pins are:
>>> +                       gpio1-gpio6 for pm8018
>>> +                       gpio1-gpio12 for pm8038
>>> +                       gpio1-gpio40 for pm8058
>>> +                       gpio1-gpio38 for pm8917
>>> +                       gpio1-gpio44 for pm8921
>>
>> I usually name pins with CAPITAL LETTERS so would be
>> "GPIO1", "GPIO2" etc, lowercase may be confusing as these are
>> names not functions or groups.
>
> I was hoping to be able to follow the pattern used in pinctrl-msm; can I say
> something nice to have you agree on this? There's no difference between pins
> and groups here.

That's OK.

>>> +- function:
>>> +       Usage: optional
>>> +       Value type: <string>
>>> +       Definition: Specify the alternative function to be configured for the
>>> +                   specified pins.  Valid values are:
>>> +                       "normal",
>>> +                       "paired",
>>> +                       "func1",
>>> +                       "func2",
>>> +                       "dtest1",
>>> +                       "dtest2",
>>> +                       "dtest3",
>>> +                       "dtest4"
>>
>> These are a bit ambigous, why doesn't the driver present functions that
>> are more specific than "func1", "func2"? Or "dtest1"?
>
> I agree, unfortunately I have only seen traces of the actual function matrix;
> for pm8xxx I have no documentation and for pm8x41 they are only listed as
> func[1-2] and dtest[1-4].
>
> Maybe if someone at Qualcomm could release such a list we could provide a
> proper table instead.

I guess Stephen Boyd can help us. (?)

>> Isn't the type simply bool?
>>
>
> No, the property is bool but the actual value is void. But looking an extra
> time in the epapr I see that it's supposed to be "empty" - so will update.

OK.

>>> +- bias-pull-up:
>>> +       Usage: optional
>>> +       Value type: <u32> (optional)
>>> +       Definition: The specified pins should be configued as pull up. An
>>> +                   optional argument can be used to configure the strength.
>>> +                   Valid values are; as defined in
>>> +                   <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
>>> +                   1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
>>> +                   2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
>>> +                   3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
>>> +                   4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
>>
>> Hm, I don't know of the internal kernel API or so, but I'm thinking that
>> for the DT bindings, this definition should be generic in
>> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>> and put in SI units like uA.
>
> Totally agree with you; and this is already specified in pinctrl-binding.txt as
> being Ohm.
>
> So I first did a spin with the strength as a separate property, but as that
> because the only part that pinconf-generic didn't parse for me I merged it and
> wanted your comment on it.

Yeah. And thinking of it.... how can it be uA? It has to be Ohms... it's a pull
up resistor thing after all. I suspect the uA value is just something like the
maximum current drawn through the pullup given a certain voltage?

>> So I would prefer:
>>
>> bias-pull-up = <30>;
>>
>
> Yeah, but that's the easy one ;)
>
> How do you say 1.5 or 31.5 and how do you differ that from 1.5 + 30 boot?

It needs to be set using Ohms.

>> for 30 uA. Maybe we want nA even? I'm uncertain about the proper granularity
>> here :-/
>>
>> Magic enumerators 1,2,3,4 doesn't seem so good, that seems more like it's
>> trying to match the magic value that is to be poked into a register or
>> something like that.
>
> The stuff going into the hardware is a value 0-3 for pull up; so these values
> are "only" an enum with the additional benefit of saying "bias-pull-up;"
> results in 30uA pull up which is the most commonly used form (hence being
> optional).

What is the nominal voltage of these pins? GIven that you can figure
out the Ohms. And I suspect it to be something very close to N times
the resistance of a depleted transistor in this technology.

>>> +- drive-strength:
>>> +       Usage: optional
>>> +       Value type: <u32>
>>> +       Definition: Selects the drive strength for the specified pins. Value
>>> +                   drive strengths are:
>>> +                       0: no   (PM8XXX_GPIO_STRENGTH_NO)
>>> +                       1: high (PM8XXX_GPIO_STRENGTH_HIGH)
>>> +                       2: medium       (PM8XXX_GPIO_STRENGTH_MED)
>>> +                       3: low  (PM8XXX_GPIO_STRENGTH_LOW)
>>
>> I would really prefer to have these in mA, because the genric pinconf
>> bindings say they should be! SI units are so much more understandable.
>
> This is all the information to be found in the available documentation and
> code. Maybe someone from Qualcomm can shed some light on it?

Stephen?

>>> +                            <234 1>, <235 1>;
>>
>>
>> So this looks a bit weird. But if I just get to understand the hardware
>> I guess it won't anymore.
>>
>> So there is an interrupt parent to which the IRQ lines from the PMIC
>> are routed back through external lines to IRQ offsets 192 thru 235?
>
> The pm8921-core exposes 256 interrupts, the listed 44 interrupts here are what
> comes out of that.

I get it. It makes sense to handle all IRQs in the core rather than spawning
yet another irqchip for the pin control driver.

> I was really reluctant to list all the interrupts, but I think it turned out
> nicer than any of my other attempts; like only providing a base and then
> relying on interrupts being consecutive.

I agree.

Yours,
Linus Walleij
