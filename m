Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3AKWlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:41:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22775 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3AKWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:09 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 00/22] PCI, ACPI: pci root bus hotplug support / pci match_driver
Date: Fri, 11 Jan 2013 14:40:27 -0800
Message-Id: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It includes
1. preparing patches for pci root bus hotadd/hotremove support
2. move root bus hotadd from acpiphp to pci_root.c
3. add hot-remove support
4. clean up hotadd/remove with common functions
5. add acpi_hp_work to be shared with acpiphp and root-bus hotplug
6. add match_driver to add pci device to device tree early but
   not attach driver for hotplug path.

based on pci/next

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug

After this patchset, will send out
	 for_each_host_bridge support
	 for_each_dev_addon_res

Jiang Liu (4):
  PCI: Fix a device reference count leakage issue in pci_dev_present()
  PCI: make PCI device create/destroy logic symmetric
  PCI: split registration of PCI bus devices into two stages
  PCI: correctly detect ACPI PCI host bridge objects

Tang Chen (2):
  ACPI: Introduce a new acpi handle to determine HID match.
  PCI, ACPI: debug print for installation of acpi root bridge's notifier

Yinghai Lu (16):
  PCI, acpiphp: Add is_hotplug_bridge detection
  PCI: Add root bus children dev's res to fail list
  PCI: Set dev_node early for pci_dev
  ACPI: Separate acpi_bus_trim to support two steps.
  PCI, acpiphp: Separate out hot-add support of pci host bridge
  PCI, ACPI: Add pci_root_hp hot removal notification support.
  PCI, ACPI: remove acpi_root_bridge in pci_root_hp
  ACPI: update ej_event interface to take acpi_device
  ACPI, PCI: Simplify handle_root_bridge_removal()
  PCI, acpiphp: Don't bailout even no slots found yet.
  PCI, ACPI: Add alloc_acpi_hp_work()
  PCI, acpiphp: Use acpi_hp_work
  PCI, pci_root_hp: Use acpi_hp_work
  PCI, ACPI: Make kacpi_hotplug_wq static
  PCI: add match_driver in struct pci_dev
  PCI: move device_add out of pci_bus_add_device()

 drivers/acpi/acpi_memhotplug.c     |    2 +-
 drivers/acpi/osl.c                 |   24 ++++-
 drivers/acpi/pci_root.c            |  180 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/processor_driver.c    |    2 +-
 drivers/acpi/scan.c                |   52 ++++++++---
 drivers/pci/bus.c                  |   57 +++---------
 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_core.c |   23 +----
 drivers/pci/hotplug/acpiphp_glue.c |  150 ++++++++++--------------------
 drivers/pci/iov.c                  |    7 --
 drivers/pci/pci-driver.c           |    6 +-
 drivers/pci/probe.c                |   40 ++++++--
 drivers/pci/remove.c               |   14 +--
 drivers/pci/search.c               |   10 +-
 drivers/pci/setup-bus.c            |    2 +-
 include/acpi/acpi_bus.h            |    4 +-
 include/acpi/acpiosxf.h            |    9 +-
 include/linux/pci.h                |    1 +
 18 files changed, 365 insertions(+), 219 deletions(-)

-- 
1.7.10.4

