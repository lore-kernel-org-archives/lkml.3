Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaDYJTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:19:45 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:45708 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaDYJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:19:39 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 00/13] Refactor pci_is_brdige() to simplify code
Date: Fri, 25 Apr 2014 17:18:22 +0800
Message-ID: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset rename the current pci_is_bridge() to pci_has_subordinate(), 
and introduce a new pci_is_bridge() which determine pci bridge by check
dev->hdr_type. The new one is more accurate. PCIe Spec define the pci
device is a bridge by the dev->hdr_type = 0x01 || 0x02.

Yijing Wang (13):
  PCI: rename pci_is_bridge() to pci_has_subordinate()
  PCI: Introduce new pci_is_bridge() helper function
  PCI: Use new pci_is_bridge() to simplify code
  x86/PCI: Use new pci_is_bridge() to simplify code
  IA64/PCI: Use new pci_is_bridge() to simplify code
  powerpc/PCI: Use new pci_is_bridge() to simplify code
  sparc/PCI: Use new pci_is_bridge() to simplify code
  PCI, rpaphp: Use new pci_is_bridge() to simplify code
  PCI, shpchp: Use new pci_is_bridge() to simplify code
  PCI, cpcihp: Use new pci_is_bridge() to simplify code
  PCI, acpiphp: Use new pci_is_bridge() to simplify code
  PCI, pcmcia: Use new pci_is_bridge() to simplify code
  PCI, pciehp: Use new pci_is_bridge() to simplify code

 arch/ia64/pci/fixup.c                  |    4 +---
 arch/powerpc/kernel/pci-hotplug.c      |    3 +--
 arch/powerpc/kernel/pci_of_scan.c      |    3 +--
 arch/sparc/kernel/pci.c                |    3 +--
 arch/x86/pci/fixup.c                   |    4 +---
 drivers/pci/hotplug/acpiphp_glue.c     |    3 +--
 drivers/pci/hotplug/cpci_hotplug_pci.c |    3 +--
 drivers/pci/hotplug/pciehp_pci.c       |    3 +--
 drivers/pci/hotplug/rpadlpar_core.c    |    3 +--
 drivers/pci/hotplug/shpchp_pci.c       |    3 +--
 drivers/pci/pci-acpi.c                 |    8 +-------
 drivers/pci/pci-driver.c               |    8 ++++----
 drivers/pci/pci.h                      |    2 +-
 drivers/pci/probe.c                    |    3 +--
 drivers/pci/setup-bus.c                |    4 +---
 drivers/pcmcia/cardbus.c               |    3 +--
 include/linux/pci.h                    |    6 ++++++
 17 files changed, 25 insertions(+), 41 deletions(-)


