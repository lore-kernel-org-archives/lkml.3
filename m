Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaBTJDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:03:55 -0500
Received: from 6.mo68.mail-out.ovh.net ([46.105.63.100]:55398 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754810AbaBTI7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:59:31 -0500
Message-ID: <5305C3EB.5080107@overkiz.com>
Date: Thu, 20 Feb 2014 09:59:23 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/8] ARM: at91: Add at91sam9rl DT SoC support
References: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com> <1392823951-26053-2-git-send-email-alexandre.belloni@free-electrons.com> <20140219170020.GA25079@e106331-lin.cambridge.arm.com> <20140219173141.GB3038@piout.net> <20140219175409.GF25079@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140219175409.GF25079@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14117658932048197857
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 19/02/2014 18:54, Mark Rutland wrote:
> On Wed, Feb 19, 2014 at 05:31:42PM +0000, Alexandre Belloni wrote:
>> On 19/02/2014 at 17:00:20 +0000, Mark Rutland wrote :
>>> On Wed, Feb 19, 2014 at 03:32:24PM +0000, Alexandre Belloni wrote:
>>>> This adds preliminary DT support for the at91sam9rl.
>>>>
>>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>>> ---
>>>>   arch/arm/boot/dts/at91sam9rl.dtsi | 628 ++++++++++++++++++++++++++++++++++++++
>>>>   arch/arm/mach-at91/at91sam9rl.c   |  16 +
>>>>   2 files changed, 644 insertions(+)
>>>>   create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
>>>   
>>> [...]
>>>
>>>> +                       tcb0: timer@fffa0000 {
>>>> +                               compatible = "atmel,at91rm9200-tcb";
>>>> +                               reg = <0xfffa0000 0x100>;
>>>> +                               interrupts = <16 IRQ_TYPE_LEVEL_HIGH 0
>>>> +                                             17 IRQ_TYPE_LEVEL_HIGH 0
>>>> +                                             18 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> +                       };
>>> Nit: please bracket list entries individually. Also for other list
>>> properties like reg and (*-)gpio(s).
>>>
>> OK.
>>
>>> [...]
>>>
>>>> +                       adc0: adc@fffd0000 {
>>>> +                               compatible = "atmel,at91sam9260-adc";
>>>> +                               reg = <0xfffd0000 0x100>;
>>>> +                               interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> +                               atmel,adc-use-external-triggers;
>>>> +                               atmel,adc-channels-used = <0xf>;
>>>> +                               atmel,adc-vref = <3300>;
>>>> +                               atmel,adc-num-channels = <4>;
>>>> +                               atmel,adc-startup-time = <15>;
>>>> +                               atmel,adc-channel-base = <0x30>;
>>>> +                               atmel,adc-drdy-mask = <0x10000>;
>>>> +                               atmel,adc-status-register = <0x1c>;
>>>> +                               atmel,adc-trigger-register = <0x04>;
>>>> +                               atmel,adc-res = <8 10>;
>>>> +                               atmel,adc-res-names = "lowres", "highres";
>>>> +                               atmel,adc-use-res = "highres";
>>>> +
>>>> +                               trigger@0 {
>>>> +                                       trigger-name = "timer-counter-0";
>>>> +                                       trigger-value = <0x1>;
>>>> +                               };
>>> A unit-address should go with a reg value. Either this needs a reg and
>>> the parent node needs #address-cells and #size-cells, or the
>>> unit-address should go, and the names made unique through other means.
>>>
>> OK, I guess I'll have to fix
>> Documentation/devicetree/bindings/arm/atmel-adc.txt too.
> Yes please.
>
>>> [...]
>>>
>>>> +                       pinctrl@fffff400 {
>>>> +                               #address-cells = <1>;
>>>> +                               #size-cells = <1>;
>>>> +                               compatible = "atmel,at91rm9200-pinctrl", "simple-bus";
>>> NAK. Either this is a atmel,at91rm9200-pinctrl node or a simple-bus. Not
>>> both; that doesn't make any sense.
>>>
>> Simply a copy paste, I'll fix that here and also the 6 other atmel
>> dtsi includes.
>>
>> What is your preference for those using:
>> compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus"; ?
> A node should by either a bus or a pinctrl node.
>
> If it has chidren then the simple-bus should be separated out into a
> separate node. If there are no children simple-bus should go.

Doing this clearly break backward compatibility (the current pinctrl 
drivers relies on
gpio controller being subnodes of the pinctrl node), but I'm interested 
in how you would
have represented this.

Could you give us an example ?


>
> Cheers,
> Mark.

