Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbaGURpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:45:36 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53042 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629AbaGURpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <53C92D70.6050604@atmel.com>
References: <1405022394-8311-1-git-send-email-boris.brezillon@free-electrons.com>
 <1405022394-8311-2-git-send-email-boris.brezillon@free-electrons.com> <53C92D70.6050604@atmel.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 21 Jul 2014 10:44:51 -0700
Message-ID: <CAGVrzcb3WHyMOW91EjDEsWfMWKb4M_cpauQtY7E+1W7zacR8VQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ARM: at91/dt: describe rgmii ethernet phy
 connected to sama5d3xek boards
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-18 7:21 GMT-07:00 Nicolas Ferre <nicolas.ferre@atmel.com>:
> On 10/07/2014 21:59, Boris BREZILLON :
>> Add ethernet-phy nodes and specify phy interrupt (connected to pin PB25)
>> and board specific timing configs.
>>
>> Atmel has two different HW designs for its CPU modules: the first one
>> (produced by Embest) is connecting PHYAD[0-2] pins to pull up resistors
>> and the other one (produced by Ronetix) is connecting PHYAD0 to a pull up
>> resistor and PHYAD[1-2] to pull down resistors.
>> As a result, Ronetix design will have its PHY available at address 0x1 and
>> Embest design at 0x7.
>> By defining both phys we're letting the phy core detect the one actually
>> available on the MDIO bus.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>
>> Florian, I dropped your Reviewed-by tag because this patch has slightly
>> changed.
>
> Hi Florian,
>
> I would like to have your Ack on this one as we discussed this solution
> with you.

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

>
> Thanks, bye,
>
>
>>  arch/arm/boot/dts/sama5d3xcm.dtsi | 30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
>> index b0b1331..755369e 100644
>> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
>> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
>> @@ -34,6 +34,36 @@
>>
>>                       macb0: ethernet@f0028000 {
>>                               phy-mode = "rgmii";
>> +                             #address-cells = <1>;
>> +                             #size-cells = <0>;
>> +
>> +                             ethernet-phy@1 {
>> +                                     reg = <0x1>;
>> +                                     interrupt-parent = <&pioB>;
>> +                                     interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
>> +                                     txen-skew-ps = <800>;
>> +                                     txc-skew-ps = <3000>;
>> +                                     rxdv-skew-ps = <400>;
>> +                                     rxc-skew-ps = <3000>;
>> +                                     rxd0-skew-ps = <400>;
>> +                                     rxd1-skew-ps = <400>;
>> +                                     rxd2-skew-ps = <400>;
>> +                                     rxd3-skew-ps = <400>;
>> +                             };
>> +
>> +                             ethernet-phy@7 {
>> +                                     reg = <0x7>;
>> +                                     interrupt-parent = <&pioB>;
>> +                                     interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
>> +                                     txen-skew-ps = <800>;
>> +                                     txc-skew-ps = <3000>;
>> +                                     rxdv-skew-ps = <400>;
>> +                                     rxc-skew-ps = <3000>;
>> +                                     rxd0-skew-ps = <400>;
>> +                                     rxd1-skew-ps = <400>;
>> +                                     rxd2-skew-ps = <400>;
>> +                                     rxd3-skew-ps = <400>;
>> +                             };
>>                       };
>>
>>                       pmc: pmc@fffffc00 {
>>
>
>
> --
> Nicolas Ferre



-- 
Florian
