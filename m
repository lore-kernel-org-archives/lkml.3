Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaFQF0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:26:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:25172 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbaFQF0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:26:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="549014929"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Patch V2 00/16] Enable support of IOAPIC hotplug on x86 platforms
Date: Tue, 17 Jun 2014 13:29:39 +0800
Message-Id: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enhances IOAPIC core and ACPI drivers to support IOAPIC
hotplug on x86 platforms. It's based on another patch set "use irqdomain
to dynamically allocate IRQ for IOAPIC" at
https://lkml.org/lkml/2014/6/9/44

You may pull it from 
https://github.com/jiangliu/linux.git ioapic/hotplug_v2

We have pick up several patches from Yinghai's original IOAPIC hotplug
patch set and reimplemented IOAPIC driver as an ACPI driver instead of
a PCI driver.

It has been tested on a 4-socket Intel SDV with socket hot-addition
capability. Any suggestions are welcomed!

Jiang Liu (10):
  x86, irq, ACPI: protect acpi_pci_irq_enable() from reentrance
  PCI: kill wrong warning message in pcieport driver
  x86, irq: remove __init marker for functions will be used by IOAPIC
    hotplug
  x86, irq: refine mp_register_ioapic() to prepare for IOAPIC hotplug
  x86, irq, ACPI: introduce a rwsem to protect IOAPIC operations from
    hotplug
  x86, irq, ACPI: implement interface to support ACPI based IOAPIC
    hot-addition
  x86, irq, ACPI: implement interface to support ACPI based IOAPIC
    hot-removal
  x86, irq: introduce helper to check whether an IOAPIC has been
    registered
  pci, ioapic: kill ioapic PCI driver
  x86, irq, ACPI: implement ACPI driver to support IOAPIC hotplug

Yinghai Lu (6):
  x86, irq: Split out alloc_ioapic_save_registers()
  x86, ioapic: Find usable ioapic id for 64bit.
  ACPI, x86/PCI: Move resource_to_addr() to acpi generic
  ACPI: Make map_mat_entry handle x2apic entry
  ACPI: Move acpi_get_cpuid() to separated file
  ACPI, ioapic: Add acpi_get_ioapic_id()

 arch/x86/include/asm/io_apic.h |    6 +-
 arch/x86/kernel/acpi/boot.c    |   74 +++++++++-
 arch/x86/kernel/apic/io_apic.c |  235 +++++++++++++++++++++++++-------
 arch/x86/pci/acpi.c            |   50 +------
 drivers/acpi/Kconfig           |    6 +
 drivers/acpi/Makefile          |    2 +
 drivers/acpi/apic_id.c         |  295 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/internal.h        |    7 +
 drivers/acpi/ioapic.c          |  231 +++++++++++++++++++++++++++++++
 drivers/acpi/pci_irq.c         |    7 +-
 drivers/acpi/pci_root.c        |    3 +
 drivers/acpi/processor_core.c  |  191 --------------------------
 drivers/acpi/resource.c        |   46 +++++++
 drivers/pci/Kconfig            |    7 -
 drivers/pci/Makefile           |    2 -
 drivers/pci/ioapic.c           |  121 ----------------
 drivers/pci/pcie/portdrv_pci.c |    4 -
 include/acpi/processor.h       |    3 -
 include/linux/acpi.h           |   11 ++
 19 files changed, 868 insertions(+), 433 deletions(-)
 create mode 100644 drivers/acpi/apic_id.c
 create mode 100644 drivers/acpi/ioapic.c
 delete mode 100644 drivers/pci/ioapic.c

-- 
1.7.10.4

