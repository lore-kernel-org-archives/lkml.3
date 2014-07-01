Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849AbaGASoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:44:38 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50168 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932437AbaGASoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:44:34 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 0/9] Support for creating generic PCI host bridges from DT
Date: Tue,  1 Jul 2014 19:43:25 +0100
Message-Id: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my resurected attempt at adding support for generic PCI host
bridge controllers that make use of device tree information to
configure themselves. I've tagged it as v8 although the patches
have now been reshuffled in order to ease adoption so referring to
the older versions might be a bit of a hoop jumping exercise.

Changes from v7:
  - Reordered the patches so that fixes and non-controversial patches
    from v7 can be accepted more easily. If agreed I can split the
    series again into patches that can be upstreamed easily and ones
    that still need discussion.
  - Moved the of_create_host_bridge() function to drivers/of/of_pci.c
    to better reflect its target use.
  - Added the function to remap the bus I/O resources that used to be
    provided in my arm64 patch series and (re)named it pci_remap_iospace()
  - Removed error code checking from parsing and mapping of IRQ from DT
    in recognition that some PCI devices will not have legacy IRQ mappings.

v7 thread here with all the historic information: https://lkml.org/lkml/2014/3/14/279

Best regards,
Liviu


Liviu Dudau (9):
  Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
  pci: Export find_pci_host_bridge() function.
  pci: Introduce pci_register_io_range() helper function.
  pci: OF: Fix the conversion of IO ranges into IO resources.
  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
  pci: Introduce a domain number for pci_host_bridge.
  pci: of: Parse and map the IRQ when adding the PCI device.
  pci: Add support for creating a generic host_bridge from device tree
  pci: Remap I/O bus resources into CPU space with pci_remap_iospace()

 drivers/of/address.c       | 108 ++++++++++++++++++++++++++++++++++++
 drivers/of/of_pci.c        | 135 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/host-bridge.c  |  21 ++++++-
 drivers/pci/pci.c          |  37 +++++++++++++
 drivers/pci/probe.c        |  68 ++++++++++++++++-------
 include/asm-generic/io.h   |   2 +-
 include/linux/of_address.h |  14 +----
 include/linux/of_pci.h     |  10 ++++
 include/linux/pci.h        |  15 +++++
 9 files changed, 376 insertions(+), 34 deletions(-)

-- 
2.0.0

