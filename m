Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab3K3WlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21631 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3K3Wkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 00/12] PCI: Double removing fix and allocate 64bit mmio pref
Date: Sat, 30 Nov 2013 14:40:26 -0800
Message-Id: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First 4 are for Gu Zheng <guz.fnst@cn.fujitsu.com> to help double pci
device removing via sysfs.
For patch 4, rafael like to have use lock instead of atomic.

Patch 6 are for not enabling realloc auto when 64bit mmio is not there for
root bus.

Others are about mmio 64 allocation that could help Guo Chao <yan@linux.vnet.ibm.com> on powerpc mmio allocation.
It will try to assign 64 bit resource above 4g at first.

Patch 1-4 and Patch 5-12 could be appliey seperatedly.

Could be found:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-3.14

And it is based on current pci/for-linus.

-v2: update after patch that move device_del down to pci_destroy_dev.
     add "Try best to allocate pref mmio 64bit above 4G"

-v3: refresh and send out after pci_clip_resource() changes,
     as Bjorn is not happy with attachments.

Yinghai Lu (12):
  PCI: Use device_release_driver in pci_stop_root_bus
  PCI: Move back pci_proc_attach_devices calling
  PCI: Move resources and bus_list releasing to pci_release_dev
  PCI: Destroy pci dev only once
  PCI: pcibus address to resource converting take bus instead of dev
  PCI: Only enable realloc auto when root bus has 64bit mmio
  PCI: Don't use 4G bus address directly in resource allocation
  PCI: Try to allocate mem64 above 4G at first
  PCI: Kill PCIBIOS_MAX_MEM_32
  PCI: Try best to allocate pref mmio 64bit above 4g
  PCI: Sort pci root bus resources list
  intel-gtt: Read 64bit for gmar_bus_addr

 arch/x86/include/asm/pci.h   |   1 -
 drivers/char/agp/intel-gtt.c |  14 ++--
 drivers/pci/bus.c            |  74 ++++++++++++++++---
 drivers/pci/host-bridge.c    |  34 +++++----
 drivers/pci/probe.c          |  23 +++++-
 drivers/pci/remove.c         |  31 ++------
 drivers/pci/setup-bus.c      | 165 ++++++++++++++++++++++++++++++-------------
 drivers/pci/setup-res.c      |  14 +++-
 include/linux/pci.h          |  10 +--
 9 files changed, 257 insertions(+), 109 deletions(-)

-- 
1.8.1.4

