Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaKQJi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:38:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:60152 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaKQJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:38:55 -0500
Date: Mon, 17 Nov 2014 10:38:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Yijing Wang <wangyijing@huawei.com>, g@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH 00/10] Save MSI chip in pci_sys_data
In-Reply-To: <20141117025914.GC4280@google.com>
Message-ID: <alpine.DEB.2.11.1411171035270.3909@nanos>
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com> <20141112042359.GK28161@google.com> <20141117025914.GC4280@google.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2014, Bjorn Helgaas wrote:
> On Tue, Nov 11, 2014 at 09:23:59PM -0700, Bjorn Helgaas wrote:
> > On Mon, Oct 27, 2014 at 03:48:37PM +0800, Yijing Wang wrote:
> > > Yijing Wang (10):
> > >   MSI: Rename msi_chip to msi_controller for better readability
> > >   PCI/MSI: Introduce weak pcibios_msi_controller()
> > >   arm/MSI: Save MSI controller in pci_sys_data
> > >   PCI: tegra: Save MSI controller in pci_sys_data
> > >   PCI: designware: Save MSI controller in pci_sys_data
> > >   PCI: rcar: Save MSI controller in pci_sys_data
> > >   PCI: mvebu: Save MSI controller in pci_sys_data
> > >   PCI: xilinx: Save MSI controller in pci_sys_data
> > >   arm/PCI: Clean unused pcibios_add_bus() and pcibios_remove_bus()
> > >   PCI/MSI: Remove useless bus->msi assignment
> > 
> > Applied to pci/msi for v3.19, thanks.
> 
> This series is currently in the pci "next" branch, but the fact that there
> are so many MSI-related changes from so many people makes me worry that
> we're heading for a merge problem.
> 
> Here are the outstanding IRQ- and MSI-related things I've seen:
> 
>   Marc   10/25 [00/03] genirq: Add support for "split-EOI" irqchips
>   Yijing 10/27 [00/10] Save MSI chip in pci_sys_data
>   Yijing 10/27 [00/16] Use MSI controller framework to configure MSI/MSI-X
>   Jiang  10/27 [Part1 v3 00/20] Prepare for enabling hierarchy irqdomain on x86
>   Jiang  11/02 [v8 00/18] Enable support of IOAPIC hotplug on x86 platforms
>   Jiang  11/06 [Part2 v5 00/31] Enable hierarchy irqdomian on x86 platforms
>   Jiang  11/09 [Part3 v3 00/38] Enable hierarchy irqdomian on x86 platforms
>   Marc   11/11 [00/15] arm64: PCI/MSI: GICv3 ITS support (stacked domain edition)
>   Thomas 11/12 [00/16] genirq: Hierarchical irq domains and generic MSI interrupt code
>   Jiang  11/15 [V2 00/09] Refine generic/PCI MSI irqodmian interfaces
>   Marc   11/15 [00/02] Stacked domains and MSI improvements
> 
> PCI is only a minor participant, and I certainly don't have the expertise
> to deal with all this, so I suspect that I should just drop these from the
> PCI tree and let Thomas deal with them.  It seems like it would make more
> sense to get all this stuff merged together in a single tree rather than
> having some come via PCI and others come from via other trees.

The simplest way to dead with it is that I pull in pci/msi (assuming
that it contains only the above) and base the rest of it on top, so I
can deal with the resulting conflicts. So you still can keep that in
your pile and no matter who sends the pull request first everything
will just fall in place.

Thanks,

	tglx
