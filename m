Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaKLOrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:47:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:42020 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaKLOrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:47:45 -0500
Date: Wed, 12 Nov 2014 15:46:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [RFC Part4 v1 00/17] Refine support of non-PCI-compliant
 Message
In-Reply-To: <546364FA.7010806@arm.com>
Message-ID: <alpine.DEB.2.11.1411121512270.3935@nanos>
References: <1415545839-28263-1-git-send-email-jiang.liu@linux.intel.com> <546364FA.7010806@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Marc Zyngier wrote:
> This patch introduces two optionnal fields to the msi_chip structure:
> - a pointer to an irq domain, describing the MSI domain associated
>   with this msi_chip. To be populated with msi_create_irq_domain.
> - a domain_alloc_irqs() callback that has the same purpose as
>   arch_setup_msi_irqs(), with the above domain as an additional
>   parameter.
> 
> If both of these fields are non-NULL, then domain_alloc_irqs() is
> called, bypassing the setup_irq callback. This allows the MSI driver
> to use the domain stacking feature without mandating core support in
> the architecture.

I'd rather have the callback in the irqdomain itself. Along with a
callback to free the interrupts.

AFAICT is msi_chip more or less a wrapper around the actual MSI irq
domain. So we rather move towards assigning irqdomain to the pci bus
and get rid of msi_chip instead of adding another level of obscure
indirection through msi_chip.

Thanks,

	tglx

