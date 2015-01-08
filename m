Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbbAHCaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:30:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:32320 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbbAHCaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:30:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509086776"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [RFC Patch 00/19] Improve ACPI resource parsing interfaces and data structures
Date: Thu,  8 Jan 2015 10:32:47 +0800
Message-Id: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During enabling ACPI based IOAPIC hotplug, Thomas noticed some issues
in ACPI resource parsing interfaces. So this is an effort to improve them.

Patch 1-12 improve ACPI resource parsing interfaces and also fixes some
bugs.

Patch 13-19 try to share the common data structure resource_list_entry
between PCI and ACPI. It may also be shared with PNP too.

The patchset is based on v3.19-rc3 and you may get it from:
https://github.com/jiangliu/linux.git acpires_v1

Jiang Liu (11):
  ACPI: Fix a bug in parsing ACPI Memroy24 resource
  ACPI: Normalize return value of resource parser functions
  ACPI: Set flag IORESOURCE_UNSET for unassigned resources
  ACPI: Enforce stricter checks for address space descriptors
  ACPI: Return translation offset when parsing ACPI address space
    resources
  ACPI: Translate resource into master side address for bridge window
    resources
  ACPI: Add field offset to struct resource_list_entry
  ACPI: Introduce helper function acpi_dev_filter_resource_type()
  resources: Move struct resource_list_entry from ACPI into resource
    core
  PCI: Use common resource list management code instead of private
    implementation
  x86/PCI/ACPI: Use common ACPI resource interfaces to simplify
    implementation

Thomas Gleixner (8):
  ACPI: Remove redundant check in function
    acpi_dev_resource_address_space()
  ACPI: Implement proper length checks for mem resources
  ACPI: Use the length check for io resources as well
  ACPI: Let the parser return false for disabled resources
  ACPI: Provide union for address_space64 and ext_address_space64
  ACPI: Unify the parsing of address_space and ext_address_space
  ACPI: Move the window flag logic to the combined parser
  ACPI: Add prefetch decoding to the address space parser

 arch/arm/kernel/bios32.c            |    5 +-
 arch/x86/pci/acpi.c                 |  297 ++++++++++---------------------
 arch/x86/pci/bus_numa.c             |    4 +-
 drivers/acpi/acpi_lpss.c            |    6 +-
 drivers/acpi/acpi_platform.c        |    2 +-
 drivers/acpi/resource.c             |  333 ++++++++++++++++++++++-------------
 drivers/dma/acpi-dma.c              |    8 +-
 drivers/pci/bus.c                   |   18 +-
 drivers/pci/host-bridge.c           |    8 +-
 drivers/pci/host/pci-host-generic.c |    4 +-
 drivers/pci/host/pci-xgene.c        |    4 +-
 drivers/pci/host/pcie-xilinx.c      |    4 +-
 drivers/pci/probe.c                 |   10 +-
 drivers/pnp/pnpacpi/rsparser.c      |    4 +-
 include/acpi/acrestyp.h             |   49 ++++--
 include/linux/acpi.h                |   12 +-
 include/linux/ioport.h              |   25 +++
 include/linux/pci.h                 |    8 +-
 kernel/resource.c                   |   48 +++++
 19 files changed, 452 insertions(+), 397 deletions(-)

-- 
1.7.10.4

