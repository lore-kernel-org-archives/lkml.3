Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbaKUKtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:49:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:56074 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKUKtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:49:15 -0500
Date: Fri, 21 Nov 2014 11:49:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
In-Reply-To: <546F140B.1050607@arm.com>
Message-ID: <alpine.DEB.2.11.1411211142051.6439@nanos>
References: <546E1771.4030201@arm.com> <546E93DC.8010902@huawei.com> <alpine.DEB.2.11.1411210233250.6439@nanos> <546F140B.1050607@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc,

On Fri, 21 Nov 2014, Marc Zyngier wrote:
> On 21/11/14 01:46, Thomas Gleixner wrote:
> > So the real question is:
> > 
> >    What is the association level requirement to properly identify the
> >    irqdomain for a specific device on any given architecture with and
> >    without IOMMU, interrupt redirection etc.
> > 
> > To be honest: I don't know.
> > 
> > My gut feeling tells me that it's at the device level, but I really
> > leave that decision to the experts in that field.
> 
> Given the above requirement (single device associated to DMAR), I can
> see two possibilities:
> - we represent DMAR as a single PCI bus: feels a bit artificial
> - we move the MSI domain to the device, as you suggested.
> 
> The second one seems a lot more attractive to me.

And that's very useful if you want to support MSI on non PCI
devices.

> Also, it is not clear to me what is the advantage of getting rid of the
> MSI controller. By doing so, we loose an important part of the topology
> information (the irq domain is another level of abstraction).

That was probably my misunderstanding of the msi controller. I had the
impression it's just there to expose the MSI properties of a device,
i.e. a magic wrapper which can be replaced by the MSI irqdomain work.

If that handles other information as well, then it's probably a
misnomer to begin with.

Thanks,

	tglx


