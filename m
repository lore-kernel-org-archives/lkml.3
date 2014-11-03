Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaKCT5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:57:45 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:36507
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752340AbaKCT5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:57:42 -0500
X-WSS-ID: 0NEHBFV-08-0K4-02
X-M-MSG: 
Message-ID: <5457DE24.9030302@amd.com>
Date: Mon, 3 Nov 2014 13:57:24 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "Catalin.Marinas@arm.com" <Catalin.Marinas@arm.com>,
        "Will.Deacon@arm.com" <Will.Deacon@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "Kasiviswanathan, Harish" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V9 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
References: <1414743990-28421-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1414743990-28421-3-git-send-email-suravee.suthikulpanit@amd.com>
 <alpine.DEB.2.11.1410311014050.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410311014050.5308@nanos>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(199003)(189002)(479174003)(377454003)(52604005)(102836001)(95666004)(107046002)(86362001)(106466001)(31966008)(105586002)(77156002)(62966003)(36756003)(65956001)(65806001)(33656002)(50986999)(76176999)(54356999)(47776003)(20776003)(87266999)(64706001)(65816999)(120916001)(83506001)(84676001)(99396003)(97736003)(4396001)(50466002)(87936001)(92726001)(101416001)(92566001)(23746002)(68736004)(110136001)(80316001)(21056001)(44976005)(46102003)(19580405001)(19580395003)(64126003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 4:40 AM, Thomas Gleixner wrote:
> On Fri, 31 Oct 2014, suravee.suthikulpanit@amd.com wrote:
>> +/*
>> + * alloc_msi_irq - Allocate MSIs from available MSI bitmap.
>> + * @data: Pointer to v2m_data
>> + * @nvec: Number of interrupts to allocate
>> + * @irq: Pointer to the allocated irq
>> + *
>> + * Allocates interrupts only if the contiguous range of MSIs
>> + * with specified nvec are available. Otherwise return the number
>> + * of available interrupts. If none are available, then returns -ENOENT.
>
> And the exact purpose of returning the number of available interrupts
> is?

Initially, I intended to use this function to allocate irqs for both MSI 
and multi-MSI case. But I'll simplify this and revisit it again when 
adding the multi-MSI.

>
>> +	virq = __irq_domain_alloc_irqs(v2m->domain, hwirq,
>> +				       1, NUMA_NO_NODE, v2m, true);
>
> And surely the ability of alloc_msi_irq() to allocate a contiguous
> vector space is required to satisfy an hardcoded allocation of ONE
> interrupt.
>
> What is guaranteeing that the caller only requests a single interrupt?

Since this is calling from gicv2m_setup_msi_irq(), it should only setup 
1 MSI interrupt.

 >[...]
>> +err_out:
>
> Single error exit which undoes the stuff in the same order it got
> initialized is just plain wrong. Ever looked at proper error exits in
> other kernel files?
>

I'll clean this up in V10. Thanks for pointing this out.

Suravee

