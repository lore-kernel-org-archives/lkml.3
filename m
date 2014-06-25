Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaFYHfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:35:43 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:48286 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755157AbaFYHfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:35:40 -0400
Message-ID: <53AA7BC6.3020902@atmel.com>
Date: Wed, 25 Jun 2014 15:35:34 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: at91/dt: describe rgmii ethernet phy connected
 to sama5d3xek boards
References: <1403649878-28242-1-git-send-email-boris.brezillon@free-electrons.com> <1403649878-28242-2-git-send-email-boris.brezillon@free-electrons.com> <53AA735C.7050805@atmel.com> <53AA7A8C.1010304@free-electrons.com>
In-Reply-To: <53AA7A8C.1010304@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 06/25/2014 03:30 PM, Boris BREZILLON wrote:
> Hello Bo,
>
> On 25/06/2014 08:59, Bo Shen wrote:
>> Hi Boris,
>>
>> On 06/25/2014 06:44 AM, Boris BREZILLON wrote:
>>> Add ethernet-phy node to specify phy address (on the MDIO bus) and phy
>>> interrupt (connected to pin PB25).
>>>
>>> Define board specific delays to apply to RGMII signals.
>>>
>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>> ---
>>>    arch/arm/boot/dts/sama5d3xcm.dtsi | 16 ++++++++++++++++
>>>    1 file changed, 16 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi
>>> b/arch/arm/boot/dts/sama5d3xcm.dtsi
>>> index b0b1331..2185ad8 100644
>>> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
>>> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
>>> @@ -34,6 +34,22 @@
>>>
>>>                macb0: ethernet@f0028000 {
>>>                    phy-mode = "rgmii";
>>> +                #address-cells = <1>;
>>> +                #size-cells = <0>;
>>> +
>>> +                ethernet-phy@1 {
>>
>> The GMAC PHY address is 0x7 while not 0x1.
>
> Are you sure of that ? I checked sama5d3x-ek schematics.

On sama5d3x-ek schematic, it is EMAC PHY (ksz8051RNL, it's address is 
0x1), while not GMAC PHY. You should check the sama5d3x-CM schematic.

> On these schematics PHYAD0 is connected to a pull up resistor and
> PHYAD1/2 are connected to a pull down one.
> This gives PHYAD[4:0] = 0b00001 = 0x1.
> Is there some bootloader mechanisms that changes PHYAD[0-2] pin status
> and reset the PHY ?
>
>>
>>> +                    interrupt-parent = <&pioB>;
>>> +                    interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
>>> +                    reg = <1>;
>>
>> Nitpick: as usual, we will add "0x" prefix in reg property.
>
> Sure, I'll fix that.
>
>>
>>> +                    txen-skew-ps = <800>;
>>> +                    txc-skew-ps = <12000>;
>
> Should be 3000 (0xf * 200 ps) not 12000.
>
>>> +                    rxdv-skew-ps = <400>;
>>> +                    rxc-skew-ps = <12000>;
>
> Ditto.
>
> Best Regards,
>
> Boris

Best Regards,
Bo Shen

