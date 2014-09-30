Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaI3QSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:18:13 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40247 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI3QSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:18:09 -0400
Date: Tue, 30 Sep 2014 10:18:05 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH v13 00/12] Support for creating generic PCI host bridges
 from DT
Message-ID: <20140930161805.GB5625@google.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
 <20140929194335.GA13747@google.com>
 <20140930103942.GO841@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930103942.GO841@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 11:39:42AM +0100, Liviu Dudau wrote:
> On Mon, Sep 29, 2014 at 08:43:35PM +0100, Bjorn Helgaas wrote:
> > On Mon, Sep 29, 2014 at 03:29:19PM +0100, Liviu Dudau wrote:
> > > This is my version 13 of the attempt at adding support for generic PCI host
> > > bridge controllers. It contains only cleanups to make it play nice with the
> > > linux-next tree as of 09/25. If Bjorn deems it safe, now that it looks like
> > > asm-generic is going to revert some of its more aggresive patches, he has the
> > > choice of queueing it into linux-next again.
> > > ...
> > 
> > These patches above were already on my pci/host-generic branch and in
> > linux-next:
> > 
> >    asm-generic/io.h: Fix ioport_map() for !CONFIG_GENERIC_IOMAP
> This ^ ...
> 
> >    of/pci: Add pci_register_io_range() and pci_pio_to_address()
> >    ARM: Define PCI_IOBASE as the base of virtual PCI IO space
> 
> and this ^ need to be refreshed from my series otherwise we will get conflicts with
> asm-generic branch (either now or in the future). While the asm-generic/io.h
> cast is arguably superflous, we need to define PCI_IOBASE as a void __iomem* to
> match all other standard declarations of PCI_IOBASE.
> 
> >    of/pci: Define of_pci_range_to_resource() only when CONFIG_PCI=y
> >    of/pci: Move of_pci_range_to_resources() to of/address.c
> >    of/pci: Fix the conversion of IO ranges into IO resources
> > 
> > I added these three patches to my pci/host-generic branch:
> > 
> >    PCI: Add generic domain handling
> >    of/pci: Add pci_get_new_domain_nr() and of_get_pci_domain_nr()
> >    of/pci: Add support for parsing PCI host bridge resources from DT
> 
> I can see these patches added to pci/host-generic but not on pci/next.

Right.  I leave things on topic branches for a day or two to give a chance
for Fengguang's auto-builder to find problems before I merge them into the
more public "next" or "for-linus" branches.

> > Yinghai pointed out a problem with this one, so I omitted it:
> > 
> >    PCI: Assign unassigned bus resources in pci_scan_root_bus()
> 
> Thats fine, host bridge drivers will have to work around pci_scan_root_bus() reduced
> functionality for now.

Well, it's not really "reduced functionality."  It is unchanged by this
series and host bridge drivers can continue using it the same way they have
in the past.  It's just that we'd like to make it smarter someday.

> > I added this one to my pci/host-generic branch:
> > 
> >    PCI: Add pci_remap_iospace() to map bus I/O resources
> > 
> > I assume this depends on the pci_scan_root_bus() change (if not, let me
> > know), so I omitted this one:
> > 
> >    arm64: Add architectural support for PCI
> 
> No, there is no dependency there on pci_scan_root_bus(), it can go in the series.
> The only thing that depends on a feature rich pci_scan_root_bus() is the host
> bridge driver in order to be able to use only one line to process the root bus.

OK, I rebuilt pci/host-generic from scratch.  It consists of your v13
patches + Arnd's build fix for pci_pio_to_address() in !CONFIG_OF configs.

Bjorn
