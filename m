Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3H1ITO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:19:14 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:2457
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab3H1ITK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:19:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h1155h)
Message-ID: <521DB26F.8010501@freescale.com>
Date: Wed, 28 Aug 2013 16:18:55 +0800
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
Subject: Re: [PATCH v8 1/3] DMA: Freescale: revise device tree binding document
References: <1377600123-5746-1-git-send-email-hongbo.zhang@freescale.com> <1377600123-5746-2-git-send-email-hongbo.zhang@freescale.com> <20130827112509.GH19893@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130827112509.GH19893@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 07:25 PM, Mark Rutland wrote:
> On Tue, Aug 27, 2013 at 11:42:01AM +0100, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> This patch updates the discription of each type of DMA controller and its
>> channels, it is preparation for adding another new DMA controller binding, it
>> also fixes some defects of indent for text alignment at the same time.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> ---
>>   .../devicetree/bindings/powerpc/fsl/dma.txt        |   62 +++++++++-----------
>>   1 file changed, 27 insertions(+), 35 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>> index 2a4b4bc..ddf17af 100644
>> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
>> @@ -1,33 +1,29 @@
>> -* Freescale 83xx DMA Controller
>> +* Freescale DMA Controllers
>>   
>> -Freescale PowerPC 83xx have on chip general purpose DMA controllers.
>> +** Freescale Elo DMA Controller
>> +   This is a little-endian DMA controller, used in Freescale mpc83xx series
>> +   chips such as mpc8315, mpc8349, mpc8379 etc.
>>   
>>   Required properties:
>>   
>> -- compatible        : compatible list, contains 2 entries, first is
>> -		 "fsl,CHIP-dma", where CHIP is the processor
>> -		 (mpc8349, mpc8360, etc.) and the second is
>> -		 "fsl,elo-dma"
>> -- reg               : <registers mapping for DMA general status reg>
>> -- ranges		: Should be defined as specified in 1) to describe the
>> -		  DMA controller channels.
>> +- compatible        : must include "fsl,elo-dma"
> We should list the other values that may be in the list also, unless
> they are really of no consequence, in which case their presence in dt is
> questionable.
Hmm.  Stephen questioned here too, it seems this is a default rule.
Although Scott@freescale had explained our thoughts, I'd like to edit 
this item like this:

"must include "fsl,eloplus-dma", and a "fsl,CHIP-dma" is optional, where 
CHIP is the processor name"

We don't list all the chip name because we have tens of them and we 
cannot list all of them, and it is unnecessary to list them because we 
even don't use "fsl,CHIP-dma" in the new driver, add "fsl,CHIP-dma" here 
just make it questionable when it presents in example and  old dts files.

I remove the examples in bracket "(mpc8349, mpc8360, etc.)" because we 
can see the real example below.
I don't say" if "fsl,CHIP-dma" presents, it should be the first one, and 
the "fsl,eloplus-dma" should be the second" because it is common rule.
the description language should be clear and concise too I think.
>> +- reg               : <registers specifier for DMA general status reg>
>> +- ranges            : describes the mapping between the address space of the
>> +                      DMA channels and the address space of the DMA controller
>>   - cell-index        : controller index.  0 for controller @ 0x8100
>> -- interrupts        : <interrupt mapping for DMA IRQ>
>> +- interrupts        : <interrupt specifier for DMA IRQ>
>>   - interrupt-parent  : optional, if needed for interrupt mapping
>>   
>> -
>>   - DMA channel nodes:
>> -        - compatible        : compatible list, contains 2 entries, first is
>> -			 "fsl,CHIP-dma-channel", where CHIP is the processor
>> -			 (mpc8349, mpc8350, etc.) and the second is
>> -			 "fsl,elo-dma-channel". However, see note below.
>> -        - reg               : <registers mapping for channel>
>> +        - compatible        : must include "fsl,elo-dma-channel"
>> +                              However, see note below.
> Again, I think we should list the other entries that may be in the list.
> Otherwise it's not clear what the binding defines. Similarly for the
> other compatible list definitions below...
>
>> +        - reg               : <registers specifier for channel>
>>           - cell-index        : dma channel index starts at 0.
> I realise you haven't changed it, but it's unclear what the cell-index
> property is (and somewhat confusingly there seem to be multiple
> defnitions). It might be worth clarifying it while performing the other
> cleanup.
not clear with your point "multiple definitions", we really have 
multiple dma channels for one dma controller.
cell-index is used as channel index, this is an old method used by old 
driver, my patch didn't touch this part.
>>   
>>   Optional properties:
>> -        - interrupts        : <interrupt mapping for DMA channel IRQ>
>> -			  (on 83xx this is expected to be identical to
>> -			   the interrupts property of the parent node)
>> +        - interrupts        : <interrupt specifier for DMA channel IRQ>
>> +                              (on 83xx this is expected to be identical to
>> +                              the interrupts property of the parent node)
>>           - interrupt-parent  : optional, if needed for interrupt mapping
>>   
>>   Example:
>> @@ -70,30 +66,26 @@ Example:
>>   		};
>>   	};
>>   
>> -* Freescale 85xx/86xx DMA Controller
>> -
>> -Freescale PowerPC 85xx/86xx have on chip general purpose DMA controllers.
>> +** Freescale EloPlus DMA Controller
>> +   This is DMA controller with extended addresses and chaining, mainly used in
>> +   Freescale mpc85xx/86xx, Pxxx and BSC series chips, such as mpc8540, mpc8641
>> +   p4080, bsc9131 etc.
>>   
>>   Required properties:
>>   
>> -- compatible        : compatible list, contains 2 entries, first is
>> -		 "fsl,CHIP-dma", where CHIP is the processor
>> -		 (mpc8540, mpc8540, etc.) and the second is
>> -		 "fsl,eloplus-dma"
>> -- reg               : <registers mapping for DMA general status reg>
>> +- compatible        : must include "fsl,eloplus-dma"
>> +- reg               : <registers specifier for DMA general status reg>
>>   - cell-index        : controller index.  0 for controller @ 0x21000,
>>                                            1 for controller @ 0xc000
>> -- ranges		: Should be defined as specified in 1) to describe the
>> -		  DMA controller channels.
>> +- ranges            : describes the mapping between the address space of the
>> +                      DMA channels and the address space of the DMA controller
>>   
>>   - DMA channel nodes:
>> -        - compatible        : compatible list, contains 2 entries, first is
>> -			 "fsl,CHIP-dma-channel", where CHIP is the processor
>> -			 (mpc8540, mpc8560, etc.) and the second is
>> -			 "fsl,eloplus-dma-channel". However, see note below.
>> +        - compatible        : must include "fsl,eloplus-dma-channel"
>> +                              However, see note below.
>>           - cell-index        : dma channel index starts at 0.
>> -        - reg               : <registers mapping for channel>
>> -        - interrupts        : <interrupt mapping for DMA channel IRQ>
>> +        - reg               : <registers specifier for channel>
>> +        - interrupts        : <interrupt specifier for DMA channel IRQ>
>>           - interrupt-parent  : optional, if needed for interrupt mapping
>>   
>>   Example:
>> -- 
>> 1.7.9.5
> Thanks,
> Mark.
>



