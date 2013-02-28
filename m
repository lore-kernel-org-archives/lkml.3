Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3B1J6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:58:08 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:46954 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3B1J6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:58:05 -0500
Message-ID: <512F2A29.8080708@slimlogic.co.uk>
Date: Thu, 28 Feb 2013 09:58:01 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, J Keerthy <j-keerthy@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
References: <1361164283-3133-1-git-send-email-j-keerthy@ti.com> <512E5144.9020105@wwwdotorg.org> <512F1ADF.90906@nvidia.com>
In-Reply-To: <512F1ADF.90906@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 08:52, Laxman Dewangan wrote:
> On Thursday 28 February 2013 12:02 AM, Stephen Warren wrote:
>> On 02/17/2013 10:11 PM, J Keerthy wrote:
>> +- interrupt-parent : The parent interrupt controller.
>> +
>> +Optional node:
>> +- Child nodes contain in the palmas. The palmas family is made of
>> several
>> +  variants that support a different number of features.
>> +  The child nodes will thus depend of the capability of the variant.
>> Are there DT bindings for those child nodes anywhere?
>>
>> Representing each internal component as a separate DT node feels a
>> little like designing the DT bindings to model the Linux-internal MFD
>> structure. DT bindings should be driven by the HW design and
>> OS-agnostic.
>>
>>  From a DT perspective, is there any need at all to create a separate DT
>> node for each component? This would only be needed or useful if the
>> child IP blocks (and hence DT bindings for those blocks) could be
>> re-used in other top-level devices that aren't represented by this
>> top-level ti,palmas DT binding. Are the HW IP blocks here re-used
>> anywhere, or will they be?
>
>
> I dont think that child IP block can be used outside of the palma
> although other mfd device may have same IP.
>
> The child driver very much used the palma's API for register access
> and they can not be separated untill driver is write completely
> independent of palmas API. Currently, child driver include the palma
> header, uses palma mfd stcruture and plama's api for accessing registers.
>
I wonder why break good software principles of keeping data and code
localised? Just because there is no current case where a block is
re-used does not mean it shall not be so in the future. The original
information I got from TI when designing this was blocks may be re-used
in future products.

This structure also makes it much neater when dealing with palmas
varients with different IP blocks which already exist.

I also do not see an issue with working like the internal MFD structure,
I think it is a good design.

>>> +    interrupt-controller;
>>> +    #interrupt-cells = <1>;
>>> +    interrupt-parent = <&gic>;
>>> +    #address-cells = <1>;
>>> +    #size-cells = <0>;
>>> +
>>> +    ti,mux-pad1 = <0x00>;
>>> +    ti,mux-pad2 = <0x00>;
>>> +    ti,power-ctrl = <0x03>;
>>> +
>>> +    palmas_pmic {
>> Just "pmic" seems simpler, although I dare say the node name isn't
>> really used for anything.
>
> Stephen,
> Just curios, why do we require the palma_pmic node at all, We can
> start with regulator node directly. Is it not too much nested here?
>
>
>
>>
>> +
>> +    palmas_rtc {
>> +        compatible = "ti,palmas_rtc";
>> +        interrupts = <8 9>;
>> Are the interrupt outputs of the RTC fed directly to the GIC interrupt
>> mentioned in the top-level Palmas node, or do these interrupts feed into
>> a top-level IRQ controller in the Palmas device, which then feeds into
>> the external IRQ controller?
>
> The interrupt goes to the chip-internal irq, not to external of chip. 
> We have only one int line from chip which can be connected to
> processor/GIC.
> yes, interrupt parent need to be define here to get the proper
> interrupt number.
Those interrupt lines are un-needed in the newer version of driver, I
forgot to remove them. The regmap-irq takes care of this for us without
needing this information in the DT at all.

But actually the OF handles this without requiring a parent in this
case. These interrupts are fed to the child nodes inside io_resource
entries.

Graeme

