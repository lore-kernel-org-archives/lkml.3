Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbaISV7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:59:14 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55085 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbaISV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:59:11 -0400
Date: Fri, 19 Sep 2014 15:59:05 -0600
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
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 00/10] Support for creating generic PCI host bridges
 from DT
Message-ID: <20140919215905.GB30239@google.com>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:30:15AM +0100, Liviu Dudau wrote:
> This is my version 11 of the attempt at adding support for generic PCI host
> bridge controllers that make use of device tree information to
> configure themselves. It contains minor cleanups compared with v10 to address
> the existing comments.
> ...
> Catalin Marinas (1):
>   PCI: Introduce generic domain handling for PCI busses.
> 
> Liviu Dudau (9):
>   Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
>   PCI: Introduce helper functions to deal with PCI I/O ranges.
>   ARM: Define PCI_IOBASE as the base of virtual PCI IO space.
>   PCI: OF: Fix the conversion of IO ranges into IO resources.
>   PCI: Create pci_host_bridge before its associated bus in
>     pci_create_root_bus.
>   OF: Introduce helper function for getting PCI domain_nr
>   OF: PCI: Add support for parsing PCI host bridge resources from DT
>   PCI: Assign unassigned bus resources in pci_scan_root_bus()
>   PCI: Introduce pci_remap_iospace() for remapping PCI I/O bus resources
>     into CPU space
> 
>  arch/arm/include/asm/io.h         |   1 +
>  arch/arm/mach-integrator/pci_v3.c |  23 +++---
>  drivers/of/address.c              | 146 ++++++++++++++++++++++++++++++++
>  drivers/of/of_pci.c               | 170 ++++++++++++++++++++++++++++++++++++++
>  drivers/pci/host/pci-tegra.c      |  10 ++-
>  drivers/pci/host/pcie-rcar.c      |  21 +++--
>  drivers/pci/pci.c                 |  33 ++++++++
>  drivers/pci/probe.c               |  46 +++++++----
>  include/asm-generic/io.h          |   2 +-
>  include/asm-generic/pgtable.h     |   4 +
>  include/linux/of_address.h        |  15 +---
>  include/linux/of_pci.h            |  18 ++++
>  include/linux/pci.h               |  24 ++++++
>  13 files changed, 463 insertions(+), 50 deletions(-)

I put this on a pci/liviu-generic-v11 branch.  I mentioned a couple things
in response to the individual patches, so I'm hoping you can send me
incremental patches to address them.  Then I'll update this branch, rename
it, and get it into linux-next.

Bjorn
