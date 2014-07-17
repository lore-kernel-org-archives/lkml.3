Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbaGQOvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:51:01 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:53227
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933057AbaGQOss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:48:48 -0400
X-WSS-ID: 0N8V2H4-07-HZO-02
X-M-MSG: 
Message-ID: <53C7E23D.1050900@amd.com>
Date: Thu, 17 Jul 2014 09:48:29 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>
CC: Pawel Moll <Pawel.Moll@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/4 V3] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140717131854.GN13108@titan.lakedaemon.net>
 <20140717135534.GM30313@leverpostej>
In-Reply-To: <20140717135534.GM30313@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(377454003)(479174003)(189002)(199002)(51704005)(36756003)(74502001)(65956001)(80022001)(68736004)(83322001)(44976005)(65806001)(19580405001)(19580395003)(64706001)(79102001)(47776003)(83506001)(15975445006)(20776003)(84676001)(33656002)(76482001)(21056001)(107046002)(23756003)(86362001)(99396002)(87936001)(85306003)(50466002)(65816999)(46102001)(76176999)(54356999)(106466001)(50986999)(97736001)(74662001)(31966008)(87266999)(64126003)(77982001)(81342001)(59896001)(95666004)(81542001)(101416001)(102836001)(4396001)(92726001)(85852003)(83072002)(105586002)(92566001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB033;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/2014 8:55 AM, Mark Rutland wrote:
> Hi Jason,
>
> On Thu, Jul 17, 2014 at 02:18:54PM +0100, Jason Cooper wrote:
>> On Wed, Jul 09, 2014 at 06:05:00PM -0500, suravee.suthikulpanit@amd.com wrote:
>>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>>
>>> This patch set introduces support for MSI(-X) in GICv2m specification,
>>> which is implemented in some variation of GIC400.
>>>
>>> This depends on and has been tested with the V7 of"Add support for PCI in AArch64"
>>> (https://lkml.org/lkml/2014/3/14/320).
>>>
>>> Changes in V3:
>>>      * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/gic
>>>        (per Jason Cooper request)
>>>      * Misc fix/clean up per Mark Rutland comments
>>>      * Minor Clean up in the driver/irqchip/irq-gic-v2m.c: alloc_msi_irqs()
>>>      * Patch 4 is new to the series:
>>>          * Add ARM64-specific version arch_setup_msi_irqs() to allow support
>>>            for Multiple MSI.
>>>          * Add support for Multiple MSI for GICv2m.
>>>
>>> Suravee Suthikulpanit (4):
>>>    irqchip: gic: Add binding probe for ARM GIC400
>>>    irqchip: gic: Restructuring ARM GIC code
>>>    irqchip: gic: Add supports for ARM GICv2m MSI(-X)
>>>    irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m
>>
>> Ok, patch #1 applied to irqchip/urgent.  Patches 2 and 3 applied to
>> irqchip/gic with irqchip/urgent merged in.  To facilitate
>> testing/merging, I've prepared an unsigned tag for you on the
>> irqchip/gic branch:
>
> I'm a little concerned that this is all going through for v3.17 without
> a {Reviewed,Acked}-by from Marc or anyone working with GIC{,v2m}.

> While his comments on v1 have been addressed, he has not had a chance to
> acknowledge the solutions. I appreciate Marc's holiday is unfortunately
> timed.
>
> I also have an open concern with the binding with regard to the
> orthogonality of GICV GICH and the MSI registers.

The MSI part is normally enabled from the optional "msi-controller" 
keyword. It should not really matter which compatible ID it uses.

Ooops. I noticed that was accidentally dropped the check for 
"msi-controller" in the gicv2m_of_init() function.  I'll send a follow 
up patch to fix this.

> Suravee, do you need this urgently for v3.17? I was under the impression
> that we wouldn't have full PCIe support by then.
>

PCI is the dependency for this patch to function.  So, it should be 
aligned with upstreaming of PCI patches.

Suravee

