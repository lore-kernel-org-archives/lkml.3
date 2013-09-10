Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3IJF7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:59:48 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:3609
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab3IJF7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:59:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <522EB594.7020907@freescale.com>
Date: Tue, 10 Sep 2013 14:00:52 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 2/3] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
References: <1377861980-7027-1-git-send-email-hongbo.zhang@freescale.com> <1377861980-7027-3-git-send-email-hongbo.zhang@freescale.com> <20130902155636.GA18206@e106331-lin.cambridge.arm.com> <5225A57E.4030003@freescale.com>
In-Reply-To: <5225A57E.4030003@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark? ping.

On 09/03/2013 05:01 PM, Hongbo Zhang wrote:
> On 09/02/2013 11:58 PM, Mark Rutland wrote:
>> Hi,
>>
>> On Fri, Aug 30, 2013 at 12:26:19PM +0100, hongbo.zhang@freescale.com 
>> wrote:
>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>
>>> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this 
>>> patch adds
>>> the device tree nodes for them.
>>>
>>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>>> ---
>>>   .../devicetree/bindings/powerpc/fsl/dma.txt        |   67 
>>> ++++++++++++++++
>>>   arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>>>   arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   82 
>>> ++++++++++++++++++++
>>>   arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   82 
>>> ++++++++++++++++++++
>>>   arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>>>   5 files changed, 235 insertions(+), 4 deletions(-)
>>>   create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>>>   create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>>>
>>> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt 
>>> b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>> index ddf17af..332ac77 100644
>>> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>> @@ -126,6 +126,73 @@ Example:
>>>                  };
>>>          };
>>>
>>> +** Freescale Elo3 DMA Controller
>>> +   This is EloPlus controller with 8 channels, used in Freescale 
>>> Txxx and Bxxx
>> I was under the impression EloPlus was the previous revision. Should
>> that say Elo3, or is Elo3 considered to be an EloPlus implementation?
> In this patch 1/3 I revise the doc to make it clear we have Elo and 
> EloPlus, and I'm adding another new Elo3. Yes the only difference 
> between Elo3 and EloPlus is channel numbers(8 channels vs 4 channels), 
> so we can call "Elo3 is an 8-channel EloPlus"
>>> +   series chips, such as t1040, t4240, b4860.
>>> +
>>> +Required properties:
>>> +
>>> +- compatible        : must include "fsl,elo3-dma"
>>> +- reg               : <registers specifier for DMA general status reg>
>> The example has two reg entries. What both are should be specified. From
>> what you described last time, it sounds like each is a status register
>> for four channels.
>>
>> Presumably the first covers the channels at 0x0,0x80,0x100,0x180, and
>> the second covers the channels at 0x300,0x380,0x400,0x480? If the
>> registers have specific names in a datasheet, it would be worth
>> mentioning them.
> Yes, each is a status register for four channels, you got it -- this 
> means my statement works.
> Is it necessary to specify all the register names?
> I can describe my two registers, but in other cases the reg entryies 
> can cover tens even hundreds of registers, just a summary is OK I think.
>> If the specification of the DMA controller allows for more channels, it
>> may be worth describing that case now.
> This DMA controller doesn't allows for more channels. (Even if it 
> does, it should be another new controller)
>>> +- ranges            : describes the mapping between the address 
>>> space of the
>>> +                      DMA channels and the address space of the DMA 
>>> controller
>> This looks odd as a required property, and I'm slightly confused. Is
>> this used to map the reg values of the DMA channels, or is it used when
>> mapping the DMA address space (for which dma-ranges exists in ePAPR and
>> other bindings).
> It is used to map the reg values of DMA channels.
>>> +
>>> +- DMA channel nodes:
>>> +        - compatible        : must include "fsl,eloplus-dma-channel"
>>> +        - reg               : <registers specifier for channel>
>> What does this represent? What are valid values?
>>
>> In the example below it looks like these are offsets of control
>> registers within the dma controller.
> Yes, they are offsets of control registers within dma controller, but 
> the contents in these registers are for dma channels.
> Physically we have dma controller registers and dma channel registers, 
> they are in one continuous physical address space, we divide all these 
> registers into two controller/channel parts, according to contents in 
> these registers, common status registers for all channels are called 
> dma controller registers, otherwise channel specific registers are 
> called dma channel registers.
>> If the reg property may have any value, how do they get mapped to bits
>> in the status register(s)?
> In fact, each channel has its own status register(and also other 
> registers), the dma controller status register is just aggregation of 
> all channel status register. (that seems duplicated somehow, maybe 
> this is due to hardware compatibility with legacy one, and the device 
> tree just describes the physical hardware without lie)
>> May some channels be unusable for some reason, or will all eight
>> channels be wired on any given Elo3 DMA?
> Sorry, not get your point clearly, maybe you are clear now because of 
> my previous explanations.
>> Cheers,
>> Mark.
>>
>>> +        - interrupts        : <interrupt specifier for DMA channel 
>>> IRQ>
>>> +        - interrupt-parent  : optional, if needed for interrupt 
>>> mapping
>>> +
>>> +Example:
>>> +dma@100300 {
>>> +       #address-cells = <1>;
>>> +       #size-cells = <1>;
>>> +       compatible = "fsl,elo3-dma";
>>> +       reg = <0x100300 0x4>,
>>> +             <0x100600 0x4>;
>>> +       ranges = <0x0 0x100100 0x500>;
>>> +       dma-channel@0 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x0 0x80>;
>>> +               interrupts = <28 2 0 0>;
>>> +       };
>>> +       dma-channel@80 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x80 0x80>;
>>> +               interrupts = <29 2 0 0>;
>>> +       };
>>> +       dma-channel@100 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x100 0x80>;
>>> +               interrupts = <30 2 0 0>;
>>> +       };
>>> +       dma-channel@180 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x180 0x80>;
>>> +               interrupts = <31 2 0 0>;
>>> +       };
>>> +       dma-channel@300 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x300 0x80>;
>>> +               interrupts = <76 2 0 0>;
>>> +       };
>>> +       dma-channel@380 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x380 0x80>;
>>> +               interrupts = <77 2 0 0>;
>>> +       };
>>> +       dma-channel@400 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x400 0x80>;
>>> +               interrupts = <78 2 0 0>;
>>> +       };
>>> +       dma-channel@480 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x480 0x80>;
>>> +               interrupts = <79 2 0 0>;
>>> +       };
>>> +};
>>> +
>>>   Note on DMA channel compatible properties: The compatible property 
>>> must say
>>>   "fsl,elo-dma-channel" or "fsl,eloplus-dma-channel" to be used by 
>>> the Elo DMA
>>>   driver (fsldma).  Any DMA channel used by fsldma cannot be used by 
>>> another
>>> diff --git a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi 
>>> b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
>>> index 7399154..ea53ea1 100644
>>> --- a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
>>> +++ b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
>>> @@ -223,13 +223,13 @@
>>>                  reg = <0xe2000 0x1000>;
>>>          };
>>>
>>> -/include/ "qoriq-dma-0.dtsi"
>>> +/include/ "elo3-dma-0.dtsi"
>>>          dma@100300 {
>>>                  fsl,iommu-parent = <&pamu0>;
>>>                  fsl,liodn-reg = <&guts 0x580>; /* DMA1LIODNR */
>>>          };
>>>
>>> -/include/ "qoriq-dma-1.dtsi"
>>> +/include/ "elo3-dma-1.dtsi"
>>>          dma@101300 {
>>>                  fsl,iommu-parent = <&pamu0>;
>>>                  fsl,liodn-reg = <&guts 0x584>; /* DMA2LIODNR */
>>> diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi 
>>> b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>>> new file mode 100644
>>> index 0000000..3c210e0
>>> --- /dev/null
>>> +++ b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>>> @@ -0,0 +1,82 @@
>>> +/*
>>> + * QorIQ Elo3 DMA device tree stub [ controller @ offset 0x100000 ]
>>> + *
>>> + * Copyright 2013 Freescale Semiconductor Inc.
>>> + *
>>> + * Redistribution and use in source and binary forms, with or without
>>> + * modification, are permitted provided that the following 
>>> conditions are met:
>>> + *     * Redistributions of source code must retain the above 
>>> copyright
>>> + *       notice, this list of conditions and the following disclaimer.
>>> + *     * Redistributions in binary form must reproduce the above 
>>> copyright
>>> + *       notice, this list of conditions and the following 
>>> disclaimer in the
>>> + *       documentation and/or other materials provided with the 
>>> distribution.
>>> + *     * Neither the name of Freescale Semiconductor nor the
>>> + *       names of its contributors may be used to endorse or 
>>> promote products
>>> + *       derived from this software without specific prior written 
>>> permission.
>>> + *
>>> + *
>>> + * ALTERNATIVELY, this software may be distributed under the terms 
>>> of the
>>> + * GNU General Public License ("GPL") as published by the Free 
>>> Software
>>> + * Foundation, either version 2 of that License or (at your option) 
>>> any
>>> + * later version.
>>> + *
>>> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' 
>>> AND ANY
>>> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
>>> THE IMPLIED
>>> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
>>> PURPOSE ARE
>>> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE 
>>> FOR ANY
>>> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
>>> CONSEQUENTIAL DAMAGES
>>> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
>>> OR SERVICES;
>>> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
>>> CAUSED AND
>>> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
>>> LIABILITY, OR TORT
>>> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
>>> THE USE OF THIS
>>> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>>> + */
>>> +
>>> +dma0: dma@100300 {
>>> +       #address-cells = <1>;
>>> +       #size-cells = <1>;
>>> +       compatible = "fsl,elo3-dma";
>>> +       reg = <0x100300 0x4>,
>>> +             <0x100600 0x4>;
>>> +       ranges = <0x0 0x100100 0x500>;
>>> +       dma-channel@0 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x0 0x80>;
>>> +               interrupts = <28 2 0 0>;
>>> +       };
>>> +       dma-channel@80 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x80 0x80>;
>>> +               interrupts = <29 2 0 0>;
>>> +       };
>>> +       dma-channel@100 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x100 0x80>;
>>> +               interrupts = <30 2 0 0>;
>>> +       };
>>> +       dma-channel@180 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x180 0x80>;
>>> +               interrupts = <31 2 0 0>;
>>> +       };
>>> +       dma-channel@300 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x300 0x80>;
>>> +               interrupts = <76 2 0 0>;
>>> +       };
>>> +       dma-channel@380 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x380 0x80>;
>>> +               interrupts = <77 2 0 0>;
>>> +       };
>>> +       dma-channel@400 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x400 0x80>;
>>> +               interrupts = <78 2 0 0>;
>>> +       };
>>> +       dma-channel@480 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x480 0x80>;
>>> +               interrupts = <79 2 0 0>;
>>> +       };
>>> +};
>>> diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi 
>>> b/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>>> new file mode 100644
>>> index 0000000..cccf3bb
>>> --- /dev/null
>>> +++ b/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>>> @@ -0,0 +1,82 @@
>>> +/*
>>> + * QorIQ Elo3 DMA device tree stub [ controller @ offset 0x101000 ]
>>> + *
>>> + * Copyright 2013 Freescale Semiconductor Inc.
>>> + *
>>> + * Redistribution and use in source and binary forms, with or without
>>> + * modification, are permitted provided that the following 
>>> conditions are met:
>>> + *     * Redistributions of source code must retain the above 
>>> copyright
>>> + *       notice, this list of conditions and the following disclaimer.
>>> + *     * Redistributions in binary form must reproduce the above 
>>> copyright
>>> + *       notice, this list of conditions and the following 
>>> disclaimer in the
>>> + *       documentation and/or other materials provided with the 
>>> distribution.
>>> + *     * Neither the name of Freescale Semiconductor nor the
>>> + *       names of its contributors may be used to endorse or 
>>> promote products
>>> + *       derived from this software without specific prior written 
>>> permission.
>>> + *
>>> + *
>>> + * ALTERNATIVELY, this software may be distributed under the terms 
>>> of the
>>> + * GNU General Public License ("GPL") as published by the Free 
>>> Software
>>> + * Foundation, either version 2 of that License or (at your option) 
>>> any
>>> + * later version.
>>> + *
>>> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' 
>>> AND ANY
>>> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
>>> THE IMPLIED
>>> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
>>> PURPOSE ARE
>>> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE 
>>> FOR ANY
>>> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
>>> CONSEQUENTIAL DAMAGES
>>> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS 
>>> OR SERVICES;
>>> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
>>> CAUSED AND
>>> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
>>> LIABILITY, OR TORT
>>> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
>>> THE USE OF THIS
>>> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>>> + */
>>> +
>>> +dma1: dma@101300 {
>>> +       #address-cells = <1>;
>>> +       #size-cells = <1>;
>>> +       compatible = "fsl,elo3-dma";
>>> +       reg = <0x101300 0x4>,
>>> +             <0x101600 0x4>;
>>> +       ranges = <0x0 0x101100 0x500>;
>>> +       dma-channel@0 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x0 0x80>;
>>> +               interrupts = <32 2 0 0>;
>>> +       };
>>> +       dma-channel@80 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x80 0x80>;
>>> +               interrupts = <33 2 0 0>;
>>> +       };
>>> +       dma-channel@100 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x100 0x80>;
>>> +               interrupts = <34 2 0 0>;
>>> +       };
>>> +       dma-channel@180 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x180 0x80>;
>>> +               interrupts = <35 2 0 0>;
>>> +       };
>>> +       dma-channel@300 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x300 0x80>;
>>> +               interrupts = <80 2 0 0>;
>>> +       };
>>> +       dma-channel@380 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x380 0x80>;
>>> +               interrupts = <81 2 0 0>;
>>> +       };
>>> +       dma-channel@400 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x400 0x80>;
>>> +               interrupts = <82 2 0 0>;
>>> +       };
>>> +       dma-channel@480 {
>>> +               compatible = "fsl,eloplus-dma-channel";
>>> +               reg = <0x480 0x80>;
>>> +               interrupts = <83 2 0 0>;
>>> +       };
>>> +};
>>> diff --git a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi 
>>> b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
>>> index bd611a9..ec95c60 100644
>>> --- a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
>>> +++ b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
>>> @@ -387,8 +387,8 @@
>>>                  reg        = <0xea000 0x4000>;
>>>          };
>>>
>>> -/include/ "qoriq-dma-0.dtsi"
>>> -/include/ "qoriq-dma-1.dtsi"
>>> +/include/ "elo3-dma-0.dtsi"
>>> +/include/ "elo3-dma-1.dtsi"
>>>
>>>   /include/ "qoriq-espi-0.dtsi"
>>>          spi@110000 {
>>> -- 
>>> 1.7.9.5
>>>
>>>
>>>
>>>
>



