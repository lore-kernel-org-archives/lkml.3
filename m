Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaKLOxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:53:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:41980 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaKLOxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:53:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,369,1413270000"; 
   d="scan'208";a="635736512"
Message-ID: <54637449.4070302@linux.intel.com>
Date: Wed, 12 Nov 2014 22:52:57 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC Part4 v1 00/17] Refine support of non-PCI-compliant Message
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com> <546364FA.7010806@arm.com> <alpine.DEB.2.11.1411121512270.3935@nanos>
In-Reply-To: <alpine.DEB.2.11.1411121512270.3935@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/12 22:46, Thomas Gleixner wrote:
> On Wed, 12 Nov 2014, Marc Zyngier wrote:
>> This patch introduces two optionnal fields to the msi_chip structure:
>> - a pointer to an irq domain, describing the MSI domain associated
>>   with this msi_chip. To be populated with msi_create_irq_domain.
>> - a domain_alloc_irqs() callback that has the same purpose as
>>   arch_setup_msi_irqs(), with the above domain as an additional
>>   parameter.
>>
>> If both of these fields are non-NULL, then domain_alloc_irqs() is
>> called, bypassing the setup_irq callback. This allows the MSI driver
>> to use the domain stacking feature without mandating core support in
>> the architecture.
> 
> I'd rather have the callback in the irqdomain itself. Along with a
> callback to free the interrupts.
> 
> AFAICT is msi_chip more or less a wrapper around the actual MSI irq
> domain. So we rather move towards assigning irqdomain to the pci bus
> and get rid of msi_chip instead of adding another level of obscure
> indirection through msi_chip.
Hi Thomas and Marc,

I'm trying to replace all weak functions , such as
arch_setup_msi_irqs()/arch_setup_msi_irq(), in drivers/pci/msi.c.

The framework core changes are almost ready, but it does take time
to convert current arch_setup_msi_irqs() implementations to new
irqdomain interfaces.

Not sure whether it's the right direction to go:(
Regards!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
