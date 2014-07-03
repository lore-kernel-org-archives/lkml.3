Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016AbaGCPsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:48:15 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:35266
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964876AbaGCPsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:48:12 -0400
X-WSS-ID: 0N857VV-07-6F5-02
X-M-MSG: 
Message-ID: <53B57B1D.8090308@amd.com>
Date: Thu, 3 Jul 2014 10:47:41 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 3/3 V2] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
References: <1404314544-7762-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140702163903.GA26903@leverpostej> <53B465B9.7000407@amd.com>
 <20140703084608.GB29837@leverpostej>
In-Reply-To: <20140703084608.GB29837@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(164054003)(43784003)(51704005)(52604005)(377454003)(24454002)(479174003)(20776003)(84676001)(21056001)(74662001)(23756003)(74502001)(85306003)(81342001)(47776003)(31966008)(76482001)(64706001)(83506001)(65956001)(65806001)(101416001)(81542001)(83322001)(92726001)(19580395003)(44976005)(92566001)(68736004)(36756003)(80316001)(83072002)(99396002)(102836001)(97736001)(59896001)(76176999)(95666004)(85852003)(46102001)(93886003)(87936001)(50466002)(19580405001)(87266999)(105586002)(50986999)(65816999)(107046002)(86362001)(79102001)(80022001)(64126003)(77982001)(33656002)(54356999);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0201MB0921;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0261CCEEDF
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/2014 3:46 AM, Mark Rutland wrote:
> On Wed, Jul 02, 2014 at 09:04:09PM +0100, Suravee Suthikulanit wrote:
>> Thanks again for the review. Please see my comments below.
>>
>> On 7/2/2014 11:39 AM, Mark Rutland wrote:
>>> On Wed, Jul 02, 2014 at 04:22:23PM +0100, suravee.suthikulpanit@amd.com wrote:
>>>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>>>> index 5573c08..9e46f7f 100644
>>>> --- a/Documentation/devicetree/bindings/arm/gic.txt
>>>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>>>> @@ -12,11 +12,13 @@ Main node required properties:
>>>>
>>>>    - compatible : should be one of:
>>>>           "arm,gic-400"
>>>> +       "arm,gic-400-plus"
>>>
>>> I am not keen on this name.
>>
>> Ok, I'll change it. Any suggestion on name?  I'm not sure what is the
>> "official" product name. I've seen this in some slides from ARM. What
>> about "gic-400-v2m"??.
>
> I'll query this internally.
Thanks.

>>>> @@ -37,9 +39,16 @@ Main node required properties:
>>>>           the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
>>>>           the interrupt is wired to that CPU.  Only valid for PPI interrupts.
>>>>
>>>> -- reg : Specifies base physical address(s) and size of the GIC registers. The
>>>> -  first region is the GIC distributor register base and size. The 2nd region is
>>>> -  the GIC cpu interface register base and size.
>>>> +- reg : Specifies base physical address(s) and size of the GIC register frames.
>>>> +
>>>> +  Region | Description
>>>> +  Index  |
>>>> +  -------------------------------------------------------------------
>>>> +     0   | GIC distributor register base and size
>>>> +     1   | GIC cpu interface register base and size
>>>> +     2   | VGIC interface control register base and size (Optional)
>>>> +     3   | VGIC CPU interface register base and size (Optional)
>>>> +     4   | GICv2m MSI interface register base and size (Optional)
>>>
>>> As far as I am aware, the MSI interface is completely orthogonal to
>>> having a GICH and GICV.
>>
>> Agree. I'm not doing anything with it. I'm just listing them here since
>> they are also mentioned in the gic.txt
>>
>>>
>>> We should figure out how we expect to handle that (zero-sized reg
>>> entries? reg-names?).
>>
>> I'm not sure how VGIC stuff handles reg/size = 0.
>
> Neither am I.
>
> However, what I said was that we should figure out how we _expect_ to
> handle that case. If we have to make changes to handle it, that's fine
> given we already have to make changes to support GICv2m.

Looking through the code in virt/kvm/arm/vgic.c, I believe this would 
ended up returning -EINVAL or -ENXIO from kvm_vgic_hyp_init().

>>>
>>>>
>>>>    Optional
>>>>    - interrupts   : Interrupt source of the parent interrupt controller on
>>>> @@ -55,6 +64,10 @@ Optional
>>>>                     by a crossbar/multiplexer preceding the GIC. The GIC irq
>>>>                     input line is assigned dynamically when the corresponding
>>>>                     peripheral's crossbar line is mapped.
>>>> +
>>>> +- msi-controller : Identifies the node as an MSI controller.  This requires
>>>> +  the register region index 4.
>>>
>>> That last clarifying comment is more confusing than helpful.
>>
>> If you are referring to the table, I added that since it was easier to
>> see than scanning the text.
>
> I was referring to "This requires the register region index 4".
>
> How about:
>
> - msi-controller : Identifies the node as an MSI controller. Requried
>    for GICv2m.

OK

>>
>>> [...]
>>>
>>>> +#define GIC_V2M_MIN_SPI                        32
>>>> +#define GIC_V2M_MAX_SPI                        1024
>>>
>>> GIC interrupt IDs 1020 and above are reserved, no?
>>>
>>> Surely the max ID an SPI can take is 1019?
>>
>> Right, thanks for catching. But the spec says that the SPI ID value must
>> be in the range of 32 to 1020. I guess it was a bit unclear, but
>> definitely not 1024 :)
>
> Which spec?

This was in the "Server Base System Architecture v1.0".
>
> In the GICv2 spec I see:
>
> * "Interrupt numbers ID32-ID1019 are used for SPIs." in
>    2.2.1 Interrupt IDs.
>
> * "The GIC architecture reserves interrupt ID numbers 1020-1023 for
>    special purposes." in 3.2.5 Special interrupt numbers.
>
>>
>>>> +#define GIC_OF_MSIV2M_RANGE_INDEX      4
>>>> +
>>>> +/**
>>>> + * alloc_msi_irq - Allocate MSIs from avaialbe MSI bitmap.
>>>> + * @data: Pointer to v2m_data
>>>> + * @nvec: Number of interrupts to allocate
>>>> + * @irq: Pointer to the allocated irq
>>>> + *
>>>> + * Allocates interrupts only if the contiguous range of MSIs
>>>> + * with specified nvec are available. Otherwise return the number
>>>> + * of available interrupts. If none are available, then returns -ENOENT.
>>>> + */
>>>
>>> This function is overly complicated, and pointlessly so.
>>>
>>> It doesn't achieve anything useful as it returns the size of the _last_
>>> contiguous block rather than the _largest_ contiguous block, and the
>>> only caller (gicv2m_setup_msi_irq) doesn't even care.
>>>
>>> Simplify this to just return an error code if allocation is impossible.
>>
>> Actually, I made another mistake in the gicv2m_setup_msi_irq when
>> returning from the alloc_msi_irq().
>
> Ok.
>
>> My understanding is the arch_setup_msi_irqs() is supposed to return the
>> number of available vectors if the requested amount could not be
>> allocated. I notice that the current "drivers/pci/msi.c:
>> arch_setup_msi_irqs()" does not do so, which is okay.
>>
>> However, We are also working on adding support for multi-MSI support
>> since some of the devices we have are using it, which means we will need
>> to provide a different version of the "arch_setup_msi_irqs()" as the
>> current one does not allow (PCI_CAP_ID_MSI && nvec > 1).
>>
>> Therefore, I implemented the "alloc_msi_irq" this way to account for
>> future changes.
>
> Per my comments, I still think the function is broken given it returns
> the size of the last contiguous block of available interrupts.

Actually, the current logic for alloc_msi_irq() should do the following:
     - Return the next available contiguous block of nvec.
     - In case the requested nvec is not available, return the size of 
of the largest available range, since the for loop always call the 
"bitmap_find_next_zero_area()" from the first index of the bitmap.

Actually, let me just add the code for multiple MSIs, which should be 
making use of this function also in the V3 patch set.  That way, it 
would be clear.

Thanks,

Suravee

Suravee

