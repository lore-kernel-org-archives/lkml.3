Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3EMQIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:08:54 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37977 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3EMQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:08:52 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2, part 1 0/9] Prepare for introducing PCI bus lock interfaces
Date: Tue, 14 May 2013 00:08:24 +0800
Message-Id: <1368461313-4371-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation patchset for introducing PCI bus lock mechanisms
to protect PCI subsystem from concurrent hotplug operations.

Patch 1:
	Introduce pci_bus_{get|put}() to manage PCI bus reference count
Patch 2-3:
	pci_alloc_dev() patchset from Gu Zheng
Patch 8:
	Make PCI bus creating/destroying logic symmetric
Other:
	Minor code improvements/cleanups

Gu Zheng (2):
  PCI: Introduce pci_alloc_dev(struct pci_bus*) to replace
    alloc_pci_dev()
  PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus) instead

Jiang Liu (7):
  PCI: introduce pci_bus_{get|put}() to manage PCI bus reference count
  PCI: mark pci_scan_bus_parented() as __deprecated
  ACPI, PCI: remove unused global list acpi_pci_roots in pci_root.c
  ACPI, pci_root: use acpi_handle_print() and pr_xxx() to print messages
  PCI, IA64: minor code clean up
  PCI: make PCI host bridge/bus creating and destroying logic symmetric
  PCI, unicore, m68k: remove redundant call of pci_bus_add_devices()

 arch/ia64/sn/kernel/io_init.c     |  11 +---
 arch/m68k/platform/coldfire/pci.c |   2 +-
 arch/powerpc/kernel/pci_of_scan.c |   3 +-
 arch/sparc/kernel/pci.c           |   3 +-
 arch/tile/kernel/pci.c            |   3 --
 arch/unicore32/kernel/pci.c       |   5 --
 drivers/acpi/pci_root.c           |  96 +++++++++++++----------------------
 drivers/char/agp/alpha-agp.c      |   2 +-
 drivers/char/agp/parisc-agp.c     |   2 +-
 drivers/pci/bus.c                 |  15 ++++++
 drivers/pci/iov.c                 |   8 +--
 drivers/pci/probe.c               | 102 ++++++++++++++++++--------------------
 drivers/pci/remove.c              |   3 +-
 drivers/scsi/megaraid.c           |   2 +-
 include/acpi/acpi_bus.h           |   1 -
 include/linux/pci.h               |   9 ++--
 16 files changed, 119 insertions(+), 148 deletions(-)

-- 
1.8.1.2

