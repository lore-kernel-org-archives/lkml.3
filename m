Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBJEFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:05:00 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:8311 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaBJEE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:04:59 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH part1 v5 0/7] Introduce PCIe Device Serial Number capability support
Date: Mon, 10 Feb 2014 12:04:04 +0800
Message-ID: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/pci/pci.c                 |  160 +++++++++++++++++++++++++++++++++++--
 drivers/pci/pci.h                 |    2 +-
 drivers/pci/probe.c               |   15 +++-
 include/linux/pci.h               |    9 ++-
 5 files changed, 182 insertions(+), 14 deletions(-)


