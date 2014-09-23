Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaIWVeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:34:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:50217 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278AbaIWVeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:34:00 -0400
Date: Tue, 23 Sep 2014 23:33:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
cc: marc.zyngier@arm.com, Mark Rutland <mark.rutland@arm.com>,
        jason@lakedaemon.net, pawel.moll@arm.com, Catalin.Marinas@arm.com,
        Will.Deacon@arm.com, liviu.dudau@arm.com,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [V8 1/2] irqchip: gic: Add support for multiple MSI for ARM64
In-Reply-To: <5421A825.70201@amd.com>
Message-ID: <alpine.DEB.2.10.1409232036200.4604@nanos>
References: <1411230698-8081-1-git-send-email-suravee.suthikulpanit@amd.com> <1411230698-8081-2-git-send-email-suravee.suthikulpanit@amd.com> <alpine.DEB.2.10.1409222349560.4604@nanos> <5421A825.70201@amd.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Suravee Suthikulpanit wrote:
> > > This patch implelments the ARM64 version of arch_setup_msi_irqs(),
> > > which does not return 1 for when PCI_CAP_ID_MSI and nvec > 1.
> > 
> > I can see that myself. What your changelog is missing is the reason
> > WHY you think that copying that code from drivers/pci/msi.c and
> > removing the "PCI_CAP_ID_MSI and nvec > 1" has any value.
> 
> [Suravee] This is mainly be cause the weak version of arch_setup_msi_irqs() in
> the drivers/pci/msi.c doesn't support multi-MSI. Sorry for not being clear in
> the commit message.

Groan. I asked you: 

> > WHY you think that copying that code from drivers/pci/msi.c and
> > removing the "PCI_CAP_ID_MSI and nvec > 1" has any value.

And your answer is that the function in drivers/pci/msi.c does not
support Multi-MSI. Hell I know that myself. And there is a fricking
good reason why allocating multi-MSI via

    for_each_msi()
	alloc_msi_irq();

is wrong. And while it might work by chance, there is no guarantee
that it will work. It works for Multi-MSIX, but that has an additional
X at the end and is a different beast when it comes to interrupts.

I have no idea how crooked you are trying to work around that on the
GIC side, but its going to be wrong and convoluted.

Read and understand the MSI and MSI-X spec and the subtle differences
of interrupt delivery. And if you groked that come back with a proper
explanation why that patch makes sense or just go back to the drawing
board and do it proper.

Thanks,

	tglx




