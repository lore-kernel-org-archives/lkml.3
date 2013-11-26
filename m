Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3KZB2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:28:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25937 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3KZB2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:28:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/10] PCI: Double removing fix and allocate 64bit mmio pref
Date: Mon, 25 Nov 2013 17:28:00 -0800
Message-Id: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First 4 are for Gu Zheng <guz.fnst@cn.fujitsu.com> to help double pci
device removing via sysfs.

Second 6 are about mmio 64 allocation that could help Guo Chao <yan@linux.vnet.ibm.com> on powerpc mmio allocation.
It will try to assign 64 bit resource above 4g at first.

Could be found:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-3.14

And it is based on current pci/for-linus.

-v2: update after patch that move device_del down to pci_destroy_dev.
     add "Try best to allocate pref mmio 64bit above 4G"

Yinghai Lu (10):
  PCI: Use device_release_driver in pci_stop_root_bus
  PCI: Move back pci_proc_attach_devices calling
  PCI: Move resources and bus_list releasing to pci_release_dev
  PCI: Destroy pci dev only once
  PCI: pcibus address to resource converting take bus directly
  PCI: Add pcibios_bus_addr_to_res()
  PCI: Try to allocate mem64 above 4G at first
  PCI: Try best to allocate pref mmio 64bit above 4g
  PCI: Sort pci root bus resources list
  intel-gtt: Read 64bit for gmar_bus_addr

 arch/x86/include/asm/pci.h   |   1 -
 drivers/char/agp/intel-gtt.c |  14 +++--
 drivers/pci/bus.c            |  58 +++++++++++++++----
 drivers/pci/host-bridge.c    |  48 +++++++++++-----
 drivers/pci/pci.h            |   2 +
 drivers/pci/probe.c          |  23 ++++++--
 drivers/pci/remove.c         |  31 +++-------
 drivers/pci/setup-bus.c      | 133 ++++++++++++++++++++++++++++---------------
 drivers/pci/setup-res.c      |  14 ++++-
 include/linux/pci.h          |  10 ++--
 10 files changed, 228 insertions(+), 106 deletions(-)

-- 
1.8.1.4

