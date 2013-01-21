Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3AUVVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:21:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38457 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab3AUVV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:28 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v10 00/11] PCI, ACPI: pci root bus hotplug support / pci match_driver
Date: Mon, 21 Jan 2013 13:20:41 -0800
Message-Id: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It includes
1. preparing patches for pci root bus hotadd/hotremove support
2. move root bus hotadd from acpiphp to pci_root.c
3. add hot-remove support
4. add acpi_hp_work to be shared with acpiphp and root-bus hotplug
5. add match_driver to add pci device to device tree early but
   not attach driver for hotplug path.

based on pci/next + pm/acpi-scan

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug

-v9: merges several patches together for easy review, requested by Rafael.
-v10: address comments from Rafael.

Jiang Liu (2):
  PCI: Fix a device reference count leakage issue in pci_dev_present()
  PCI: make PCI device create/destroy logic symmetric

Tang Chen (1):
  PCI, ACPI: debug print for installation of acpi root bridge's
    notifier

Yinghai Lu (8):
  PCI, acpiphp: Add is_hotplug_bridge detection
  PCI: Add root bus children dev's res to fail list
  PCI: Set dev_node early for pci_dev
  PCI, ACPI, acpiphp: Rename alloc_acpiphp_hp_work() to alloc_acpi_hp_work
  PCI, acpiphp: Move and enhance hotplug support of pci host bridge
  PCI, acpiphp: Don't bailout even no slots found yet.
  PCI: Skip attaching driver in device_add()
  PCI: Put pci dev to device tree as early as possible

 drivers/acpi/internal.h            |    1 +
 drivers/acpi/osl.c                 |   24 +++++-
 drivers/acpi/pci_root.c            |  130 +++++++++++++++++++++++++++++++
 drivers/acpi/scan.c                |    3 +
 drivers/pci/bus.c                  |   87 +++++----------------
 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_core.c |   23 +-----
 drivers/pci/hotplug/acpiphp_glue.c |  150 +++++++++++-------------------------
 drivers/pci/iov.c                  |    9 +--
 drivers/pci/pci-driver.c           |    6 +-
 drivers/pci/pci.h                  |    1 -
 drivers/pci/probe.c                |   35 +++++++--
 drivers/pci/remove.c               |    4 +-
 drivers/pci/search.c               |   10 +--
 drivers/pci/setup-bus.c            |    2 +-
 include/acpi/acpi_bus.h            |    9 +++
 include/acpi/acpiosxf.h            |    2 -
 include/linux/pci.h                |    1 +
 18 files changed, 277 insertions(+), 221 deletions(-)

-- 
1.7.10.4

