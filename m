Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3IPK10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:27:26 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57168
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757249Ab3IPK1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:27:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zzbb2dI98dI9371I1432I4015I1447Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <5236DC91.9010907@freescale.com>
Date: Mon, 16 Sep 2013 18:25:21 +0800
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
References: <1377861980-7027-1-git-send-email-hongbo.zhang@freescale.com> <1377861980-7027-3-git-send-email-hongbo.zhang@freescale.com> <20130902155636.GA18206@e106331-lin.cambridge.arm.com> <5225A57E.4030003@freescale.com> <20130912171541.GH22013@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130912171541.GH22013@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 01:15 AM, Mark Rutland wrote:
> On Tue, Sep 03, 2013 at 10:01:50AM +0100, Hongbo Zhang wrote:
>> On 09/02/2013 11:58 PM, Mark Rutland wrote:
>>> Hi,
>>>
>>> On Fri, Aug 30, 2013 at 12:26:19PM +0100, hongbo.zhang@freescale.com wrote:
>>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>>
>>>> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch adds
>>>> the device tree nodes for them.
>>>>
>>>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>> ---
>>>>    .../devicetree/bindings/powerpc/fsl/dma.txt        |   67 ++++++++++++++++
>>>>    arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>>>>    arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   82 ++++++++++++++++++++
>>>>    arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   82 ++++++++++++++++++++
>>>>    arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>>>>    5 files changed, 235 insertions(+), 4 deletions(-)
>>>>    create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>>>>    create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>>> index ddf17af..332ac77 100644
>>>> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>>> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>>>> @@ -126,6 +126,73 @@ Example:
>>>>                   };
>>>>           };
>>>>
>>>> +** Freescale Elo3 DMA Controller
>>>> +   This is EloPlus controller with 8 channels, used in Freescale Txxx and Bxxx
>>> I was under the impression EloPlus was the previous revision. Should
>>> that say Elo3, or is Elo3 considered to be an EloPlus implementation?
>> In this patch 1/3 I revise the doc to make it clear we have Elo and
>> EloPlus, and I'm adding another new Elo3. Yes the only difference
>> between Elo3 and EloPlus is channel numbers(8 channels vs 4 channels),
>> so we can call "Elo3 is an 8-channel EloPlus"
> Ok.
>
>>>> +   series chips, such as t1040, t4240, b4860.
>>>> +
>>>> +Required properties:
>>>> +
>>>> +- compatible        : must include "fsl,elo3-dma"
>>>> +- reg               : <registers specifier for DMA general status reg>
>>> The example has two reg entries. What both are should be specified. From
>>> what you described last time, it sounds like each is a status register
>>> for four channels.
>>>
>>> Presumably the first covers the channels at 0x0,0x80,0x100,0x180, and
>>> the second covers the channels at 0x300,0x380,0x400,0x480? If the
>>> registers have specific names in a datasheet, it would be worth
>>> mentioning them.
>> Yes, each is a status register for four channels, you got it -- this
>> means my statement works.
>> Is it necessary to specify all the register names?
>> I can describe my two registers, but in other cases the reg entryies can
>> cover tens even hundreds of registers, just a summary is OK I think.
> I think there should at least be a description of which channels each
> reg entry corresponds to. I see this hasn't been done so far for the
> older Elo DMAs, but they only had 4 channels max, and one status reg.
OK, I will update the reg description to make it more clear.
>>> If the specification of the DMA controller allows for more channels, it
>>> may be worth describing that case now.
>> This DMA controller doesn't allows for more channels. (Even if it does,
>> it should be another new controller)
> Ok.
>
>>>> +- ranges            : describes the mapping between the address space of the
>>>> +                      DMA channels and the address space of the DMA controller
>>> This looks odd as a required property, and I'm slightly confused. Is
>>> this used to map the reg values of the DMA channels, or is it used when
>>> mapping the DMA address space (for which dma-ranges exists in ePAPR and
>>> other bindings).
>> It is used to map the reg values of DMA channels.
> Ok, I guess that makes sense.
>
>>>> +
>>>> +- DMA channel nodes:
>>>> +        - compatible        : must include "fsl,eloplus-dma-channel"
>>>> +        - reg               : <registers specifier for channel>
>>> What does this represent? What are valid values?
>>>
>>> In the example below it looks like these are offsets of control
>>> registers within the dma controller.
>> Yes, they are offsets of control registers within dma controller, but
>> the contents in these registers are for dma channels.
>> Physically we have dma controller registers and dma channel registers,
>> they are in one continuous physical address space, we divide all these
>> registers into two controller/channel parts, according to contents in
>> these registers, common status registers for all channels are called dma
>> controller registers, otherwise channel specific registers are called
>> dma channel registers.
> I see, so this reg represents a channels channel specific registers
> (which are distinct from the shared status registers). I was confused
> initially as to what address space they were in, but that makes sense
> with your description of ranges above.
>
>>> If the reg property may have any value, how do they get mapped to bits
>>> in the status register(s)?
>> In fact, each channel has its own status register(and also other
>> registers), the dma controller status register is just aggregation of
>> all channel status register. (that seems duplicated somehow, maybe this
>> is due to hardware compatibility with legacy one, and the device tree
>> just describes the physical hardware without lie)
> My question here was stupid, thanks for the explanation :)
>
>>> May some channels be unusable for some reason, or will all eight
>>> channels be wired on any given Elo3 DMA?
>> Sorry, not get your point clearly, maybe you are clear now because of my
>> previous explanations.
> I assume that on any El03 DMA, there won't be a case where you can't
> describe the channel at 0x80, for instance. It will always be present
> (but it might not be wired up to anything any therefore be useful)?
>
> This was related to my concerns about the status register description --
> if the channels at 0x0,0x80,0x100,0x180 weren't wired, what would get
> described in the dt? I guess that would never actually happen because
> all 8 channels must always be present in the Elo3 IP block.
Yes, for this Elo3 DMA IP block, all the 8 channels are always on.
> Thanks,
> Mark.
>



