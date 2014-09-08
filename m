Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaIHXsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:48:52 -0400
Received: from mail-by2on0103.outbound.protection.outlook.com ([207.46.100.103]:29824
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753060AbaIHXsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:48:50 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 19:48:49 EDT
X-WSS-ID: 0NBLUTJ-07-97F-02
X-M-MSG: 
Message-ID: <540E3639.5080807@amd.com>
Date: Mon, 8 Sep 2014 18:05:29 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
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
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(428002)(51704005)(24454002)(479174003)(199003)(377454003)(164054003)(189002)(80022001)(65806001)(64126003)(83322001)(68736004)(21056001)(80316001)(65956001)(64706001)(33656002)(47776003)(87936001)(19580395003)(19580405001)(20776003)(105586002)(81542001)(65816999)(59896002)(101416001)(106466001)(44976005)(81342001)(4396001)(76482001)(92726001)(86362001)(92566001)(85852003)(83072002)(85306004)(102836001)(36756003)(46102001)(97736003)(107046002)(31966008)(74502001)(74662001)(99396002)(84676001)(79102001)(54356999)(76176999)(83506001)(50986999)(87266999)(50466002)(77982001)(90102001)(95666004)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB033;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03283976A6
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2014 12:55 PM, Mark Rutland wrote:
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

Mark,

I am making change in the struct gic_chip_data to contain "v2m_list" (instead of just
a single struct v2m_data). This way, it is clear on how we should handle multiple v2m nodes
within a GIC.

As for the device tree binding, in order to handle multiple v2m nodes within a GIC,
it should not require adding another compatibility ID as it seems too complicate
to have GIC node with multiple compat IDs).

	v2m0 {
		msi-controller;
		reg = <0 0x80000 0 0x10000>;	
	};

	v2m1 {
		msi-controller;
		reg = <0 0x90000 0 0x10000>;
	};

This should work since the PCI controller uses "of_pci_find_msi_chip_by_node()" to locate the msi_chip,
we can simply just use "v2m0" or "v2m1" to specify this.

Thanks,

Suravee.

