Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936538AbaH1JDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:03:17 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:3894
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936348AbaH1JDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:03:11 -0400
X-WSS-ID: 0NB0EH1-08-UYJ-02
X-M-MSG: 
Message-ID: <53FEF046.4030804@amd.com>
Date: Thu, 28 Aug 2014 04:03:02 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
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
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2 V4] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20140814175525.GI24018@leverpostej>
In-Reply-To: <20140814175525.GI24018@leverpostej>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(479174003)(164054003)(24454002)(51704005)(199003)(377454003)(189002)(81542001)(81342001)(79102001)(87266999)(21056001)(102836001)(105586002)(92566001)(87936001)(101416001)(77982001)(64126003)(106466001)(83072002)(85852003)(95666004)(76482001)(54356999)(33656002)(36756003)(83322001)(50986999)(86362001)(97736001)(99396002)(19580395003)(110136001)(80316001)(74502001)(65816999)(59896002)(31966008)(85306004)(47776003)(90102001)(50466002)(20776003)(4396001)(23746002)(46102001)(68736004)(64706001)(92726001)(107046002)(76176999)(19580405001)(44976005)(84676001)(65956001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB047;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/14/2014 12:55 PM, Mark Rutland wrote:
> On Wed, Aug 13, 2014 at 04:00:40PM +0100, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> ARM GICv2m specification extends GICv2 to support MSI(-X) with
>> a new set of register frame. This patch introduces support for
>> the non-secure GICv2m register frame. Currently, GICV2m is available
>> in certain version of GIC-400.
>>
>> The patch introduces a new property in ARM gic binding, the v2m subnode.
>> It is optional.
>>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> Cc: Mark Rutland <Mark.Rutland@arm.com>
>> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
>> Cc: Will Deacon <Will.Deacon@arm.com>
>> ---
>>   Documentation/devicetree/bindings/arm/gic.txt |  32 ++++
>>   drivers/irqchip/Kconfig                       |   7 +
>>   drivers/irqchip/Makefile                      |   1 +
>>   drivers/irqchip/irq-gic-v2m.c                 | 215 ++++++++++++++++++++++++++
>>   drivers/irqchip/irq-gic.c                     |  75 +++++----
>>   drivers/irqchip/irq-gic.h                     |  48 ++++++
>>   6 files changed, 348 insertions(+), 30 deletions(-)
>>   create mode 100644 drivers/irqchip/irq-gic-v2m.c
>>   create mode 100644 drivers/irqchip/irq-gic.h
>>
>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>> index 5573c08..8a64179 100644
>> --- a/Documentation/devicetree/bindings/arm/gic.txt
>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>> @@ -95,3 +95,35 @@ Example:
>>                        <0x2c006000 0x2000>;
>>                  interrupts = <1 9 0xf04>;
>>          };
>> +
>> +
>> +* GICv2m extension for MSI/MSI-x support (Optional)
>> +
>> +Certain revision of GIC-400 supports MSI/MSI-x via V2M register frame.
>> +This is enabled by specifying v2m sub-node.
>> +
>> +Required properties:
>> +
>> +- msi-controller : Identifies the node as an MSI controller.
>> +
>> +- reg : GICv2m MSI interface register base and size
>> +
>> +Example:
>> +
>> +       interrupt-controller@e1101000 {
>> +               compatible = "arm,gic-400";
>> +               #interrupt-cells = <3>;
>> +               #address-cells = <2>;
>> +               #size-cells = <2>;
>> +               interrupt-controller;
>> +               interrupts = <1 8 0xf04>;
>> +               ranges = <0 0 0 0xe1100000 0 0x100000>;
>> +               reg = <0x0 0xe1110000 0 0x01000>,
>> +                     <0x0 0xe112f000 0 0x02000>,
>> +                     <0x0 0xe1140000 0 0x10000>,
>> +                     <0x0 0xe1160000 0 0x10000>;
>> +               v2m {
>> +                       msi-controller;
>> +                       reg = <0x0 0x80000 0 0x1000>;
>> +               };
>> +       };
>
> [...]
>
>> @@ -1009,6 +1012,16 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>>          if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
>>                  percpu_offset = 0;
>>
>> +       gic_data[gic_cnt].irq_chip = &gic_chip;
>> +
>> +       /* Currently, we only support one v2m subnode. */
>> +       child = of_get_child_by_name(node, "v2m");
>> +       if (child) {
>> +               ret = gicv2m_of_init(child, &gic_data[gic_cnt]);
>> +               if (ret)
>> +                       return ret;
>> +       }
>
> I can't see how you'd sanely expand this to multiple children, which was
> the main point of having a separate node for the M block.
>
> Give the M block a compatible string and look for children with that
> string.
>
> Thanks,
> Mark.
>
Good point. I can try that.

Thank,

Suravee
