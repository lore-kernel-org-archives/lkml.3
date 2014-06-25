Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaFYHaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:30:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33087 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753142AbaFYHaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:30:22 -0400
Message-ID: <53AA7A8C.1010304@free-electrons.com>
Date: Wed, 25 Jun 2014 09:30:20 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: at91/dt: describe rgmii ethernet phy connected
 to sama5d3xek boards
References: <1403649878-28242-1-git-send-email-boris.brezillon@free-electrons.com> <1403649878-28242-2-git-send-email-boris.brezillon@free-electrons.com> <53AA735C.7050805@atmel.com>
In-Reply-To: <53AA735C.7050805@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bo,

On 25/06/2014 08:59, Bo Shen wrote:
> Hi Boris,
>
> On 06/25/2014 06:44 AM, Boris BREZILLON wrote:
>> Add ethernet-phy node to specify phy address (on the MDIO bus) and phy
>> interrupt (connected to pin PB25).
>>
>> Define board specific delays to apply to RGMII signals.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>   arch/arm/boot/dts/sama5d3xcm.dtsi | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi
>> b/arch/arm/boot/dts/sama5d3xcm.dtsi
>> index b0b1331..2185ad8 100644
>> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
>> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
>> @@ -34,6 +34,22 @@
>>
>>               macb0: ethernet@f0028000 {
>>                   phy-mode = "rgmii";
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +
>> +                ethernet-phy@1 {
>
> The GMAC PHY address is 0x7 while not 0x1.

Are you sure of that ? I checked sama5d3x-ek schematics.
On these schematics PHYAD0 is connected to a pull up resistor and
PHYAD1/2 are connected to a pull down one.
This gives PHYAD[4:0] = 0b00001 = 0x1.
Is there some bootloader mechanisms that changes PHYAD[0-2] pin status
and reset the PHY ?

>
>> +                    interrupt-parent = <&pioB>;
>> +                    interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
>> +                    reg = <1>;
>
> Nitpick: as usual, we will add "0x" prefix in reg property.

Sure, I'll fix that.

>
>> +                    txen-skew-ps = <800>;
>> +                    txc-skew-ps = <12000>;

Should be 3000 (0xf * 200 ps) not 12000.

>> +                    rxdv-skew-ps = <400>;
>> +                    rxc-skew-ps = <12000>;

Ditto.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

