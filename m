Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaBTJMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:12:53 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:15262 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaBTJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:12:35 -0500
Message-ID: <5305C700.4090601@atmel.com>
Date: Thu, 20 Feb 2014 10:12:32 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gregory Clement" <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/8] ARM: at91: Add at91sam9rl DT SoC support
References: <1392823951-26053-1-git-send-email-alexandre.belloni@free-electrons.com> <1392823951-26053-2-git-send-email-alexandre.belloni@free-electrons.com> <20140219170020.GA25079@e106331-lin.cambridge.arm.com> <20140219173141.GB3038@piout.net> <20140219175409.GF25079@e106331-lin.cambridge.arm.com> <5305C3EB.5080107@overkiz.com>
In-Reply-To: <5305C3EB.5080107@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/2014 09:59, Boris BREZILLON :
> Hi Mark,
> 
> On 19/02/2014 18:54, Mark Rutland wrote:
>> On Wed, Feb 19, 2014 at 05:31:42PM +0000, Alexandre Belloni wrote:
>>> On 19/02/2014 at 17:00:20 +0000, Mark Rutland wrote :
>>>> On Wed, Feb 19, 2014 at 03:32:24PM +0000, Alexandre Belloni wrote:
>>>>> This adds preliminary DT support for the at91sam9rl.
>>>>>
>>>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>>>> ---
>>>>>   arch/arm/boot/dts/at91sam9rl.dtsi | 628 ++++++++++++++++++++++++++++++++++++++
>>>>>   arch/arm/mach-at91/at91sam9rl.c   |  16 +
>>>>>   2 files changed, 644 insertions(+)
>>>>>   create mode 100644 arch/arm/boot/dts/at91sam9rl.dtsi
>>>>   
>>>> [...]
>>>>
>>>>> +                       tcb0: timer@fffa0000 {
>>>>> +                               compatible = "atmel,at91rm9200-tcb";
>>>>> +                               reg = <0xfffa0000 0x100>;
>>>>> +                               interrupts = <16 IRQ_TYPE_LEVEL_HIGH 0
>>>>> +                                             17 IRQ_TYPE_LEVEL_HIGH 0
>>>>> +                                             18 IRQ_TYPE_LEVEL_HIGH 0>;
>>>>> +                       };
>>>> Nit: please bracket list entries individually. Also for other list
>>>> properties like reg and (*-)gpio(s).
>>>>
>>> OK.
>>>
>>>> [...]
>>>>
>>>>> +                       adc0: adc@fffd0000 {
>>>>> +                               compatible = "atmel,at91sam9260-adc";
>>>>> +                               reg = <0xfffd0000 0x100>;
>>>>> +                               interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
>>>>> +                               atmel,adc-use-external-triggers;
>>>>> +                               atmel,adc-channels-used = <0xf>;
>>>>> +                               atmel,adc-vref = <3300>;
>>>>> +                               atmel,adc-num-channels = <4>;
>>>>> +                               atmel,adc-startup-time = <15>;
>>>>> +                               atmel,adc-channel-base = <0x30>;
>>>>> +                               atmel,adc-drdy-mask = <0x10000>;
>>>>> +                               atmel,adc-status-register = <0x1c>;
>>>>> +                               atmel,adc-trigger-register = <0x04>;
>>>>> +                               atmel,adc-res = <8 10>;
>>>>> +                               atmel,adc-res-names = "lowres", "highres";
>>>>> +                               atmel,adc-use-res = "highres";
>>>>> +
>>>>> +                               trigger@0 {
>>>>> +                                       trigger-name = "timer-counter-0";
>>>>> +                                       trigger-value = <0x1>;
>>>>> +                               };
>>>> A unit-address should go with a reg value. Either this needs a reg and
>>>> the parent node needs #address-cells and #size-cells, or the
>>>> unit-address should go, and the names made unique through other means.
>>>>
>>> OK, I guess I'll have to fix
>>> Documentation/devicetree/bindings/arm/atmel-adc.txt too.
>> Yes please.
>>
>>>> [...]
>>>>
>>>>> +                       pinctrl@fffff400 {
>>>>> +                               #address-cells = <1>;
>>>>> +                               #size-cells = <1>;
>>>>> +                               compatible = "atmel,at91rm9200-pinctrl", "simple-bus";
>>>> NAK. Either this is a atmel,at91rm9200-pinctrl node or a simple-bus. Not
>>>> both; that doesn't make any sense.
>>>>
>>> Simply a copy paste, I'll fix that here and also the 6 other atmel
>>> dtsi includes.
>>>
>>> What is your preference for those using:
>>> compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus"; ?
>> A node should by either a bus or a pinctrl node.
>>
>> If it has chidren then the simple-bus should be separated out into a
>> separate node. If there are no children simple-bus should go.
> 
> Doing this clearly break backward compatibility (the current pinctrl 
> drivers relies on
> gpio controller being subnodes of the pinctrl node), but I'm interested 
> in how you would
> have represented this.

Guys, just be warned, I do not plan to rework or even push for a rework
of the pinctrl driver anytime soon.

So I am afraid but you will have to live with this DT representation of
pinctrl for quite some time (even if it doesn't make sense, sorry Mark)...

> Could you give us an example ?
> 
> 
>>
>> Cheers,
>> Mark.
> 
> 
> 


-- 
Nicolas Ferre
