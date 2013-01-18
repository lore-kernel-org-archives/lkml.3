Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3ARQIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:08:05 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46727 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3ARQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:08:00 -0500
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [RFC PATCH v5 0/8] introduce PCI bus notifier chain to get rid of the ACPI PCI subdriver interfaces
Date: Sat, 19 Jan 2013 00:07:38 +0800
Message-Id: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC patchset to address review comments in thread at:
https://patchwork.kernel.org/patch/1946851/. The patch just pasts
compilation. If no objection to the new implementation, I will
go on to modify acpiphp driver and conduct tests.

The main changes from V4 to V5 includes:
1) introduce a dedicated notifier chain for PCI buses
2) change pci_slot as built-in driver
3) unify the way to create/destroy PCI slots
4) introduce a kernel option to disable PCIe native hotplug

TODO:
1) change acpiphp as built-in and unify the way to create/destroy ACPI
   based hotplug slots.
2) change other ACPI PCI subdriver in Yinghai's root bridge hotplug series
   to use the PCI bus notifier chain.
3) Remove the ACPI PCI subdriver interface eventaully.

Jiang Liu (8):
  PCI: make PCI device create/destroy logic symmetric
  PCI: split registration of PCI bus devices into two stages
  PCI: add a blocking notifier chain for PCI bus addition/removal
  ACPI, PCI: avoid building pci_slot as module
  PCI, ACPI: hook PCI bus notifications to create/destroy PCI slots
  pci_slot: replace printk(KERN_xxx) with pr_xxx()
  PCI/PCIe: add "pci=nopciehp" to disable PCIe native hotplug
  PCI/PCIe: only claim PME from firmware when CONFIG_PCIE_PME is
    enabled

 Documentation/kernel-parameters.txt |    2 +
 drivers/acpi/Kconfig                |    5 +-
 drivers/acpi/internal.h             |    5 +
 drivers/acpi/pci_root.c             |    8 +-
 drivers/acpi/pci_slot.c             |  217 ++++++++++-------------------------
 drivers/acpi/scan.c                 |    1 +
 drivers/pci/bus.c                   |   26 ++++-
 drivers/pci/pci.c                   |    2 +
 drivers/pci/pci.h                   |    1 +
 drivers/pci/pcie/portdrv_core.c     |    7 +-
 drivers/pci/pcie/portdrv_pci.c      |    3 +
 drivers/pci/probe.c                 |    7 +-
 drivers/pci/remove.c                |   15 +--
 include/linux/pci.h                 |   21 ++++
 14 files changed, 142 insertions(+), 178 deletions(-)

-- 
1.7.9.5

