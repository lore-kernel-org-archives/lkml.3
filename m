Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaCFN1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:27:14 -0500
Received: from top.free-electrons.com ([176.31.233.9]:56294 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750805AbaCFN1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:27:11 -0500
Message-ID: <5318779C.8030901@free-electrons.com>
Date: Thu, 06 Mar 2014 14:26:52 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mvebu: add Device Tree for the Armada 385 RD board
References: <1394107868-26094-1-git-send-email-gregory.clement@free-electrons.com> <20140306131429.GJ4780@lunn.ch>
In-Reply-To: <20140306131429.GJ4780@lunn.ch>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 06/03/2014 14:14, Andrew Lunn wrote:
> On Thu, Mar 06, 2014 at 01:11:08PM +0100, Gregory CLEMENT wrote:
>> The Armada 385 RD board is the reference design board from Marvell
>> for the Armada 385 SoC. This commit adds a Device Tree description for
>> this board, which enables the following features:
>>
>>  * Network interfaces
>>  * I2C bus
>>  * Serial port
>>  * SPI bus, with a SPI flash
>>  * PCIe interface
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>> Hi,
>>
>> I have received this board only recently, so that why its device tree
>> comes only now. This patch should not cause any trouble to other part
>> of the kernel, so that's why I think it is reasonable to have it in
>> 3.15.
>>
>> Thanks,
>>
>> Gregory
>>
>>
>>  arch/arm/boot/dts/Makefile          |   3 +-
>>  arch/arm/boot/dts/armada-385-rd.dts | 104 ++++++++++++++++++++++++++++++++++++
>>  2 files changed, 106 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm/boot/dts/armada-385-rd.dts
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index f7d678808122..9155cf48e1b1 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -153,7 +153,8 @@ dtb-$(CONFIG_MACH_ARMADA_370) += \
>>  dtb-$(CONFIG_MACH_ARMADA_375) += \
>>  	armada-375-db.dtb
>>  dtb-$(CONFIG_MACH_ARMADA_38X) += \
>> -	armada-385-db.dtb
>> +	armada-385-db.dtb \
>> +	armada-385-rd.dtb
>>  dtb-$(CONFIG_MACH_ARMADA_XP) += \
>>  	armada-xp-axpwifiap.dtb \
>>  	armada-xp-db.dtb \
>> diff --git a/arch/arm/boot/dts/armada-385-rd.dts b/arch/arm/boot/dts/armada-385-rd.dts
>> new file mode 100644
>> index 000000000000..951bd91059e1
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/armada-385-rd.dts
>> @@ -0,0 +1,104 @@
>> +/*
>> + * Device Tree file for Marvell Armada 385 Reference Design board
>> + * (RD-88F6820-AP)
>> + *
>> + *  Copyright (C) 2014 Marvell
>> + *
>> + * Gregory CLEMENT <gregory.clement@free-electrons.com>
>> + * Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +/dts-v1/;
>> +#include "armada-385.dtsi"
>> +
>> +/ {
>> +	model = "Marvell Armada 385 Reference Design";
>> +	compatible = "marvell,a385-rd", "marvell,armada385", "marvell,armada38x";
>> +
>> +	chosen {
>> +		bootargs = "console=ttyS0,115200 earlyprintk";
>> +	};
>> +
>> +	memory {
>> +		device_type = "memory";
>> +		reg = <0x00000000 0x10000000>; /* 256 MB */
>> +	};
>> +
>> +	soc {
>> +		ranges = <MBUS_ID(0xf0, 0x01) 0 0xf1000000 0x100000
>> +			  MBUS_ID(0x01, 0x1d) 0 0xfff00000 0x100000>;
>> +
>> +		internal-regs {
>> +			spi@10600 {
>> +				status = "okay";
>> +
>> +				spi-flash@0 {
>> +					#address-cells = <1>;
>> +					#size-cells = <1>;
>> +					compatible = "m25p128";
> 
> Hi Gregory
> 
> I guess checkpatch.pl is probably complaining about missing vendor
> prefix?
> 

yes and also about m25p128 itself because it was not explicitly written
in Documentation/devicetree/bindings/. Actually it was written to "see the
"m25p_ids" table in drivers/mtd/devices/m25p80.c for the list of" the compatible
name.

For the first warning I can add the vendor part, but for the other warning, do we
really want to copy the m25p_ids table in Documentation/devicetree/bindings/mtd/m25p80.txt ?

>> +					reg = <0>; /* Chip select 0 */
>> +					spi-max-frequency = <108000000>;
>> +				};
>> +			};
>> +
>> +			i2c@11000 {
>> +				status = "okay";
>> +				clock-frequency = <100000>;
>> +			};
>> +
>> +			serial@12000 {
>> +				clock-frequency = <200000000>;
>> +				status = "okay";
>> +			};
>> +
>> +
>> +			/*
>> +			 * The Ethernet nodes are not ordered by
>> +			 * address on purpose. Indeed the first
>> +			 * Ethernet port of the board (Giga0) is
>> +			 * located at 0x70000 whereas the the second
>> +			 * Ethernet(Giga 1) port is located at
>> +			 * 0x30000.
>> +			 */
>> +
>> +			ethernet@70000 {
>> +				status = "okay";
>> +				phy = <&phy0>;
>> +				phy-mode = "rgmii";
>> +			};
>> +
>> +			ethernet@30000 {
>> +				status = "okay";
>> +				phy = <&phy1>;
>> +				phy-mode = "rgmii";
>> +			};
>> +
> 
> I think you can use aliases to get the order correct, independent of
> how you list them in DT. That should be a lot safer than assuming
> things are instantiated from top to bottom.

It sounds interesting, how would you do this?


Thanks,

Gregory

> 
>        Andrew
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
