Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbAMNkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:40:51 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:50941 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbAMNkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:40:49 -0500
Message-ID: <54B5205C.3000803@atmel.com>
Date: Tue, 13 Jan 2015 14:40:44 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <khilman@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        ARM Maintainers <arm@kernel.org>
Subject: Re: [PATCH] ARM: at91/Documentation: add a README for Atmel SoCs
References: <1420809631-26923-1-git-send-email-nicolas.ferre@atmel.com> <54B500CC.6020205@atmel.com> <20150113113657.GB3843@piout.net>
In-Reply-To: <20150113113657.GB3843@piout.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2015 12:36, Alexandre Belloni a écrit :
> On 13/01/2015 at 12:26:04 +0100, Nicolas Ferre wrote :
>> Le 09/01/2015 14:20, Nicolas Ferre a écrit :
>>> Add a README file to describe Atmel SoCs (aka AT91) support in Mainline Linux:
>>> - SoC list + datasheet web links
>>> - Basic but useful information
>>> - Device Tree conventions and Work In Progress statement.
>>>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> Cc: ARM Maintainers <arm@kernel.org>
>>> ---
>>>  Documentation/arm/Atmel/README | 120 +++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 120 insertions(+)
>>>  create mode 100644 Documentation/arm/Atmel/README
>>>
>>> diff --git a/Documentation/arm/Atmel/README b/Documentation/arm/Atmel/README
>>> new file mode 100644
>>> index 000000000000..538f8a556277
>>> --- /dev/null
>>> +++ b/Documentation/arm/Atmel/README
>>> @@ -0,0 +1,120 @@
>>> +ARM Atmel SoCs (aka AT91)
>>> +=========================
>>> +
>>> +
>>> +Introduction
>>> +------------
>>> +This document gives useful information about the ARM Atmel SoCs that are
>>> +currently supported in Linux Mainline (you know, the one on kernel.org).
>>> +
>>> +It is important to note that the Atmel | SMART ARM-based MPU product line is
>>> +historically named "AT91" or "at91" throughout the Linux kernel development
>>> +process even if this product prefix has completely disappeared from the
>>> +official Atmel product name. Anyway, files, directories, git trees,
>>> +git branches/tags and email subject always contain this "at91" sub-string.
>>> +
>>> +
>>> +AT91 SoCs
>>> +---------
>>> +Documentation and detailled datasheet for each product are available on
>>> +the Atmel website: http://www.atmel.com.
>>> +
>>> +  Flavors:
>>> +    * ARM 920 based SoC
>>> +      - at91rm9200
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/doc1768.pdf
>>> +
>>> +    * ARM 926 based SoCs
>>> +      - at91sam9260
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/doc6221.pdf
>>> +
> 
> at91sam9xe is still supported, the datasheet is there:
> http://www.atmel.com/Images/Atmel-6254-32-bit-ARM926EJ-S-Embedded-Microprocessor-SAM9XE_Datasheet.pdf

Ok, I add it. Thanks.


>>> +      - at91sam9261
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/doc6062.pdf
>>> +
>>> +      - at91sam9263
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/Atmel_6249_32-bit-ARM926EJ-S-Microcontroller_SAM9263_Datasheet.pdf
>>> +
>>> +      - at91sam9rl
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/doc6289.pdf
>>> +
>>> +      - at91sam9g20
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/doc6384.pdf
>>> +
>>> +      - at91sam9g45 family
>>> +        - at91sam9g45
>>> +        - at91sam9g46
>>> +        - at91sam9m10
>>> +        - at91sam9m11 (device superset)
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/Atmel-6437-32-bit-ARM926-Embedded-Microprocessor-SAM9M11_Datasheet.pdf
>>> +
>>> +      - at91sam9x5 family (aka "The 5 series")
>>> +        - at91sam9g15
>>> +        - at91sam9g25
>>> +        - at91sam9g35
>>> +        - at91sam9x25
>>> +        - at91sam9x35
>>> +        + Datasheet (can be considered as covering the whole family)
>>> +          http://www.atmel.com/Images/Atmel_11055_32-bit-ARM926EJ-S-Microcontroller_SAM9X35_Datasheet.pdf
>>> +
>>> +      - at91sam9n12
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/Atmel_11063_32-bit-ARM926EJ-S-Microcontroller_SAM9N12CN11CN12_Datasheet.pdf
>>> +
>>> +    * ARM Cortex-A5 based SoCs
>>> +      - sama5d3 family
>>> +        - sama5d31
>>> +        - sama5d33
>>> +        - sama5d34
>>> +        - sama5d35
>>> +        - sama5d36 (device superset)
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/Atmel-11121-32-bit-Cortex-A5-Microcontroller-SAMA5D3_Datasheet.pdf
>>> +
>>> +    * ARM Cortex-A5 + NEON based SoCs
>>> +      - sama5d4 family
>>> +        - sama5d41
>>> +        - sama5d42
>>> +        - sama5d43
>>> +        - sama5d44 (device superset)
>>> +        + Datasheet
>>> +          http://www.atmel.com/Images/Atmel-11238-32-bit-Cortex-A5-Microcontroller-SAMA5D4_Datasheet.pdf
>>> +
>>> +
>>> +Linux kernel information
>>> +------------------------
>>> +Linux kernel mach directory: arch/arm/mach-at91
>>> +MAINTAINERS entry is: "ARM/ATMEL AT91RM9200 AND AT91SAM ARM ARCHITECTURES"
>>> +
>>> +
>>> +Device Tree for AT91 SoCs and boards
>>> +------------------------------------
>>> +All AT91 SoCs are converted to Device Tree. Since Linux 3.19, these products
>>> +must use this method to boot the Linux kernel.
>>> +
>>> +Work In Progress statement:
>>> +Device Tree files and Device Tree bindings that apply to AT91 SoCs and boards are
>>> +considered as "Unstable". To be completely clear, any at91 binding can change at
>>> +any time. So, be sure to use a Device Tree Binary and a Kernel Image generated from
>>> +the same source tree.
>>> +Please refer to the Documentation/devicetree/bindings/ABI.txt file for a
>>> +definition of a "Stable" binding/ABI.
>>> +This statement will be removed by AT91 MAINTAINERS when appropriated.
>>> +
>>> +Naming conventions and best practice:
>>> +- SoCs Device Tree Source Include files are named after the official name of
>>> +  the product (at91sam9g20.dtsi or sama5d33.dtsi for instance).
>>> +- Device Tree Source Include files (.dtsi) are used to collect common nodes that can be
>>> +  shared across SoCs or boards (sama5d3.dtsi or at91sam9x5cm.dtsi for instance).
>>> +  When collecting nodes for a particular peripheral or topic, the identifier have to
>>> +  be placed at the end of the file name, separated with a "_" (at91sam9x5_can.dtsi
>>> +  or sama5d3_gmac.dtsi for example).
>>> +- board Device Tree Source files (.dts) are prefixed by the string "at91-" so
>>> +  that they can be identified easily. Note that the sama5d3[13456]ek.dts files
>>> +  are an historical exception to this rule.
>>
>> In fact, this set of boards are not the only exception. I will rephrase
>> the sentence as:
>> "Note that some files are historical exceptions to this rule
>> (sama5d3[13456]ek.dts, usb_a9g20.dts or animeo_ip.dts for example)."
>>
>> Bye,
>> -- 
>> Nicolas Ferre
> 


-- 
Nicolas Ferre
