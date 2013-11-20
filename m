Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3KTV27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:28:59 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:41387 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3KTV2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:28:55 -0500
Date: Wed, 20 Nov 2013 14:28:51 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [GIT PULL] PCI updates for v3.13
Message-ID: <20131120212851.GA3658@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4fbf888accb39af423f271111d44e8186f053723:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-11-14 17:19:58 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.13-fixes-1

for you to fetch changes up to 30b7fc1277c74667d0d5421526dc5f7a7fa926c5:

  PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove() (2013-11-18 17:02:45 -0700)

----------------------------------------------------------------
PCI updates for v3.13:

  Miscellaneous
    - Avoid CPU switch for .probe() methods (Alexander Duyck)
    - Restore work_on_cpu() lockdep annotation (Bjorn Helgaas)
    - Remove duplicate disable from pcie_portdrv_remove() (Yinghai Lu)
    - Fix whitespace, capitalization, and spelling errors (Bjorn Helgaas)

----------------------------------------------------------------
Alexander Duyck (1):
      PCI: Avoid unnecessary CPU switch when calling driver .probe() method

Bjorn Helgaas (2):
      PCI: Fix whitespace, capitalization, and spelling errors
      Revert "workqueue: allow work_on_cpu() to be called recursively"

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

 drivers/pci/ats.c                       |   2 +-
 drivers/pci/host/pci-tegra.c            |  12 ++--
 drivers/pci/host/pcie-designware.c      |   2 +-
 drivers/pci/hotplug/Kconfig             |   4 +-
 drivers/pci/hotplug/Makefile            |   2 +-
 drivers/pci/hotplug/acpiphp_core.c      |  12 ++--
 drivers/pci/hotplug/acpiphp_glue.c      |   2 +-
 drivers/pci/hotplug/acpiphp_ibm.c       |  14 ++--
 drivers/pci/hotplug/cpci_hotplug_core.c |   2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c  |   2 +-
 drivers/pci/hotplug/cpcihp_generic.c    |  20 +++---
 drivers/pci/hotplug/cpcihp_zt5550.c     |  22 +++----
 drivers/pci/hotplug/cpcihp_zt5550.h     |  18 +++---
 drivers/pci/hotplug/cpqphp_core.c       |   4 +-
 drivers/pci/hotplug/cpqphp_ctrl.c       |  10 +--
 drivers/pci/hotplug/cpqphp_pci.c        |   5 +-
 drivers/pci/hotplug/ibmphp.h            |  12 ++--
 drivers/pci/hotplug/ibmphp_core.c       | 109 ++++++++++++++++----------------
 drivers/pci/hotplug/ibmphp_ebda.c       | 103 +++++++++++++++---------------
 drivers/pci/hotplug/ibmphp_hpc.c        |  24 +++----
 drivers/pci/hotplug/ibmphp_pci.c        |  71 ++++++++++-----------
 drivers/pci/hotplug/ibmphp_res.c        |  76 +++++++++++-----------
 drivers/pci/hotplug/pci_hotplug_core.c  |   8 +--
 drivers/pci/hotplug/pciehp.h            |   2 +-
 drivers/pci/hotplug/pciehp_acpi.c       |   2 +-
 drivers/pci/hotplug/pciehp_core.c       |   4 +-
 drivers/pci/hotplug/pciehp_hpc.c        |   6 +-
 drivers/pci/hotplug/pcihp_skeleton.c    |   8 +--
 drivers/pci/hotplug/rpadlpar_core.c     |   2 +-
 drivers/pci/hotplug/rpaphp.h            |   6 +-
 drivers/pci/hotplug/rpaphp_core.c       |   8 +--
 drivers/pci/hotplug/rpaphp_pci.c        |   3 +-
 drivers/pci/hotplug/rpaphp_slot.c       |  19 +++---
 drivers/pci/hotplug/shpchp.h            |   8 +--
 drivers/pci/hotplug/shpchp_core.c       |  10 +--
 drivers/pci/hotplug/shpchp_hpc.c        |   2 +-
 drivers/pci/iov.c                       |   2 +-
 drivers/pci/irq.c                       |   2 +-
 drivers/pci/msi.c                       |   2 +-
 drivers/pci/pci-acpi.c                  |   2 +-
 drivers/pci/pci-driver.c                |  40 ++++++++----
 drivers/pci/pci-stub.c                  |   4 +-
 drivers/pci/pci-sysfs.c                 |  28 ++++----
 drivers/pci/pci.c                       |  46 +++++++-------
 drivers/pci/pcie/aer/aerdrv_core.c      |   2 +-
 drivers/pci/pcie/aspm.c                 |   2 +-
 drivers/pci/pcie/pme.c                  |   4 +-
 drivers/pci/pcie/portdrv.h              |   2 +-
 drivers/pci/pcie/portdrv_bus.c          |   4 +-
 drivers/pci/pcie/portdrv_core.c         |   2 +-
 drivers/pci/pcie/portdrv_pci.c          |   7 +-
 drivers/pci/probe.c                     |  10 +--
 drivers/pci/proc.c                      |   2 +-
 drivers/pci/quirks.c                    | 104 +++++++++++++++---------------
 drivers/pci/remove.c                    |   2 +-
 drivers/pci/search.c                    |  12 ++--
 drivers/pci/setup-bus.c                 |  18 +++---
 drivers/pci/setup-res.c                 |   2 +-
 drivers/pci/slot.c                      |   2 +-
 drivers/pci/syscall.c                   |   2 +-
 include/linux/msi.h                     |  10 +--
 include/linux/pci.h                     |  55 ++++++++--------
 include/linux/pci_hotplug.h             |   5 +-
 include/linux/pcieport_if.h             |   2 +-
 include/uapi/linux/pci_regs.h           |  72 ++++++++++-----------
 kernel/workqueue.c                      |  32 +++-------
 66 files changed, 547 insertions(+), 548 deletions(-)
