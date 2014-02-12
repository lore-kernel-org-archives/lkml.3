Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaBLCy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:54:27 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:13393 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaBLCyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:54:22 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH part1 v6 0/7] Introduce PCIe Device Serial Number capability support
Date: Wed, 12 Feb 2014 10:52:46 +0800
Message-ID: <1392173573-59844-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5->v6: Add is_frozen flag to protect pci bus from double frozen.

This series is based on Bjorn's pci-next branch.
Currently, more and more PCIe devices support PCIe DSN(Device Serial Number)
capability, we can use this cap to identify device. In some platform,
when we hotplug PCIe device, no interrupts will be received in system.
So we can not identify the device whether is changed during suspend.
PCIe DSN can help to identify this. 

Legacy PCI device can achieve it by PCI Vital Product Data capability.
We can use its SN keyword to report the unique number.
But in my platform, PCI devices which support VPD SN cap report the
meaningless same string "0123456789". 
Rework PCI VPD code to support device identification is not an easy work.
Plan to do it in part2.

Yijing Wang (7):
  PCI: rework pci_find_next_ext_capability()
  PCI: introduce pci_bus_find_ext_capability()
  PCI: Add support for Device Serial Number capability
  PCI: Introduce pci_serial_number_changed()
  PCI: Add pci_dummy_ops to isolate pci device temporarily
  PCI: Check pci device serial number when scan device
  PCI: pciehp: Don't enable/disable slot on resume unless status
    changed

 drivers/pci/hotplug/pciehp_core.c |   10 ++-
 drivers/pci/pci.c                 |  169 +++++++++++++++++++++++++++++++++++--
 drivers/pci/pci.h                 |    2 +-
 drivers/pci/probe.c               |   15 +++-
 include/linux/pci.h               |   10 ++-
 5 files changed, 192 insertions(+), 14 deletions(-)


