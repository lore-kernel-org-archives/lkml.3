Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaKUBqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:46:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:54144 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbaKUBqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:46:14 -0500
Date: Fri, 21 Nov 2014 02:46:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yijing Wang <wangyijing@huawei.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
In-Reply-To: <546E93DC.8010902@huawei.com>
Message-ID: <alpine.DEB.2.11.1411210233250.6439@nanos>
References: <546E1771.4030201@arm.com> <546E93DC.8010902@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Yijing Wang wrote:
> On 2014/11/21 0:31, Marc Zyngier wrote:
> > Bjorn, Yijing,
> > 
> > I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
> > bus->msi assignment) completely breaks MSI on arm64 when using the new
> > MSI stacked domain:
> 
> Sorry, this is my first part to refactor MSI related code, now how
> to get pci msi_controller depends arch
> functions(pcibios_msi_controller() or arch_setup_msi_irq()), we are
> working on generic pci_host_bridge, after that, we could eventually
> eliminate MSI arch functions and find pci dev 's msi controller by
> pci_host_bridge->get_msi_controller().

The main question is why you think that pci_host_bridge is the proper
place to store that information.

On x86 we have DMAR units associated to a single device. Each DMAR
unit is a seperate MSI irq domain. 

Can you guarantee that the pci_host_bridge is the right point to
provide the association of the device to the irq domain?

So the real question is:

   What is the association level requirement to properly identify the
   irqdomain for a specific device on any given architecture with and
   without IOMMU, interrupt redirection etc.

To be honest: I don't know.

My gut feeling tells me that it's at the device level, but I really
leave that decision to the experts in that field.

Thanks,

	tglx
