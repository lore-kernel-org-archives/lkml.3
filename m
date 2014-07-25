Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbaGYKnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:43:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaGYKnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:43:14 -0400
Message-ID: <53D234BD.2040005@suse.de>
Date: Fri, 25 Jul 2014 12:43:09 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Harini Katakam <harini.katakam@xilinx.com>
CC: Michal Simek <michals@xilinx.com>, "monstr@monstr.eu" <monstr@monstr.eu>,
        Soren Brinkmann <sorenb@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-6-git-send-email-afaerber@suse.de> <ddb38ce5-9e31-4c94-967c-7784c7fba75c@BN1BFFO11FD028.protection.gbl> <53D20E5B.9070501@monstr.eu> <53D21887.2020305@suse.de> <53D2258B.9000609@xilinx.com> <7aabd35a-0b4a-4d03-9976-ef3926929ddc@BL2FFO11FD027.protection.gbl>
In-Reply-To: <7aabd35a-0b4a-4d03-9976-ef3926929ddc@BL2FFO11FD027.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harini,

Am 25.07.2014 12:31, schrieb Harini Katakam:
>> -----Original Message-----
>> From: Michal Simek [mailto:michal.simek@xilinx.com]
>> Sent: Friday, July 25, 2014 3:08 PM
>> To: Andreas Färber; monstr@monstr.eu; Soren Brinkmann
>> Cc: Harini Katakam; Michal Simek; Andreas Olofsson; Matteo Vit; Sean
>> Rickerd; devicetree@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; Rob Herring; Pawel Moll; Mark Rutland; Ian
>> Campbell; Kumar Gala; Russell King
>> Subject: Re: [PATCH v2 05/11] ARM: dts: zynq: Add QSPI for Parallella
>>
>> On 07/25/2014 10:42 AM, Andreas Färber wrote:
>>> Am 25.07.2014 09:59, schrieb Michal Simek:
>>>> On 07/25/2014 01:18 AM, Sören Brinkmann wrote:
>>>>> On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
>>>>>> Prepare SPI0 and SPI1 while at it.
>>>
>>>> Patch subject is incorrect. You are adding SPI and QSPI.
>>>
>>> Yes, it originally added only QSPI, but I considered it a good deed to
>>> add SPI as well while already reading that part of the TRM. :)
>>>
>>>>>>
>>>>>> Signed-off-by: Andreas Färber <afaerber@suse.de> --- v2: New
>>>>>>
>>>>>> arch/arm/boot/dts/zynq-7000.dtsi      | 37
>>>>>> +++++++++++++++++++++++++++++++++++
>>>>>> arch/arm/boot/dts/zynq-parallella.dts |  4 ++++ 2 files
>>>>>> changed, 41 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi
>>>>>> b/arch/arm/boot/dts/zynq-7000.dtsi index 8fd826a..eed3df0
>>>>>> 100644 --- a/arch/arm/boot/dts/zynq-7000.dtsi +++
>>>>>> b/arch/arm/boot/dts/zynq-7000.dtsi @@ -122,6 +122,30 @@
>>>>>> interrupts = <0 50 4>; };
>>>>>>
>>>>>> +		spi0: spi@e0006000 { +			compatible =
>> "xlnx,zynq-spi-r1p6";
>>>>>> +			reg = <0xe0006000 0x1000>; +			status
>> = "disabled"; +
>>>>>> interrupt-parent = <&intc>; +			interrupts = <0 26 4>;
>> +
>>>>>> clocks = <&clkc 25>, <&clkc 34>; +			clock-names =
>> "ref_clk",
>>>>>> "pclk"; +			#address-cells = <1>; +			#size-
>> cells = <0>; +		};
>>>>>> + +		spi1: spi@e0007000 { +			compatible =
>>>>>> "xlnx,zynq-spi-r1p6"; +			reg = <0xe0007000 0x1000>; +
>> 			status
>>>>>> = "disabled"; +			interrupt-parent = <&intc>; +
>> 		interrupts =
>>>>>> <0 49 4>; +			clocks = <&clkc 26>, <&clkc 35>; +
>> 		clock-names
>>>>>> = "ref_clk", "pclk"; +			#address-cells = <1>; +
>> 		#size-cells
>>>>>> = <0>; +		}; +
>>>>> Until here things look good.
>>>>>
>>>>>> gem0: ethernet@e000b000 { compatible = "cdns,gem"; reg =
>>>>>> <0xe000b000 0x4000>; @@ -140,6 +164,19 @@ clock-names = "pclk",
>>>>>> "hclk", "tx_clk"; };
>>>>>>
>>>>>> +		qspi: qspi@e000d000 { +			compatible =
>>>>>> "xlnx,zynq-spi-r1p6"; +			reg = <0xe000d000 0x1000>; +
>> 			status
>>>>>> = "disabled"; +			interrupt-parent = <&intc>; +
>> 		interrupts =
>>>>>> <0 19 4>; +			clocks = <&clkc 10>, <&clkc 43>; +
>> 		clock-names
>>>>>> = "ref_clk", "pclk"; +			num-cs = <1>; +
>> 	#address-cells =
>>>>>> <1>; +			#size-cells = <0>; +		}; +
>>>>> I'm not sure what the status of this driver is. I think QSPI is
>>>>> still under review on the mailing lists and I don't think we
>>>>> should add this yet.
>>>
>>>> Driver for qspi is not in the mainline yet but it doesn't mean that
>>>> this fragment won't work. Harini: Can you please correct me if I am
>>>> wrong?
>>>
> 
> It can be added but it will have to be disabled as there is no qspi driver
> at the moment in mainline.

Did you read the actual patch? It's using the upstream SPI driver for
now, and it's disabled for anything but the new board I'm adding.

https://patchwork.kernel.org/patch/4620201/

Wouldn't a dedicated QSPI driver only result in a compatible string
being prepended before the SPI compatible string?

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
