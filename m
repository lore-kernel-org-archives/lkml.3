Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaI2Tns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:43:48 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45460 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaI2Tnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:43:43 -0400
Date: Mon, 29 Sep 2014 13:43:35 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
Message-ID: <20140929194335.GA13747@google.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 03:29:19PM +0100, Liviu Dudau wrote:
> This is my version 13 of the attempt at adding support for generic PCI host
> bridge controllers. It contains only cleanups to make it play nice with the
> linux-next tree as of 09/25. If Bjorn deems it safe, now that it looks like
> asm-generic is going to revert some of its more aggresive patches, he has the
> choice of queueing it into linux-next again.
> ...

These patches above were already on my pci/host-generic branch and in
linux-next:

   asm-generic/io.h: Fix ioport_map() for !CONFIG_GENERIC_IOMAP
   of/pci: Add pci_register_io_range() and pci_pio_to_address()
   ARM: Define PCI_IOBASE as the base of virtual PCI IO space
   of/pci: Define of_pci_range_to_resource() only when CONFIG_PCI=y
   of/pci: Move of_pci_range_to_resources() to of/address.c
   of/pci: Fix the conversion of IO ranges into IO resources

I added these three patches to my pci/host-generic branch:

   PCI: Add generic domain handling
   of/pci: Add pci_get_new_domain_nr() and of_get_pci_domain_nr()
   of/pci: Add support for parsing PCI host bridge resources from DT

Yinghai pointed out a problem with this one, so I omitted it:

   PCI: Assign unassigned bus resources in pci_scan_root_bus()

I added this one to my pci/host-generic branch:

   PCI: Add pci_remap_iospace() to map bus I/O resources

I assume this depends on the pci_scan_root_bus() change (if not, let me
know), so I omitted this one:

   arm64: Add architectural support for PCI

Bjorn
