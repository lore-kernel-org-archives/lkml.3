Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3AVW5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:57:01 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:57047 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab3AVW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:56:58 -0500
Date: Tue, 22 Jan 2013 15:56:57 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
        Colin Ian King <colin.king@canonical.com>,
        Betty Dall <betty.dall@hp.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] PCI updates for v3.8
Message-ID: <20130122225657.GA14800@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some more fixes for v3.8.  The most important is a fix for a
pciehp deadlock that occurs when unplugging a Thunderbolt adapter.  We also
applied the same fix to shpchp, removed CONFIG_EXPERIMENTAL dependencies,
fixed a pcie_aspm=force problem, and fixed a refcount leak.

Bjorn


The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/3.8-pci-fixes-2

for you to fetch changes up to 444ee9bd3d0fa78317c6127c961af5accf50038b:

  PCI: remove depends on CONFIG_EXPERIMENTAL (2013-01-17 16:22:05 -0700)

----------------------------------------------------------------
PCI updates for v3.8:

  Hotplug
      PCI: pciehp: Use per-slot workqueues to avoid deadlock
      PCI: shpchp: Make shpchp_wq non-ordered
      PCI: shpchp: Handle push button event asynchronously
      PCI: shpchp: Use per-slot workqueues to avoid deadlock
  Power management
      PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported
  Misc
      PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()
      PCI: remove depends on CONFIG_EXPERIMENTAL

----------------------------------------------------------------
Betty Dall (1):
      PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_put()

Bjorn Helgaas (4):
      PCI: shpchp: Make shpchp_wq non-ordered
      PCI: shpchp: Handle push button event asynchronously
      PCI: shpchp: Use per-slot workqueues to avoid deadlock
      Merge branch 'pci/yijing-hotplug-workqueues' into for-linus

Colin Ian King (1):
      PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported

Kees Cook (1):
      PCI: remove depends on CONFIG_EXPERIMENTAL

Yijing Wang (1):
      PCI: pciehp: Use per-slot workqueues to avoid deadlock

 drivers/pci/hotplug/pciehp.h       |  2 +-
 drivers/pci/hotplug/pciehp_core.c  | 11 ++---------
 drivers/pci/hotplug/pciehp_ctrl.c  |  8 ++++----
 drivers/pci/hotplug/pciehp_hpc.c   | 11 ++++++++++-
 drivers/pci/hotplug/shpchp.h       |  3 +--
 drivers/pci/hotplug/shpchp_core.c  | 36 ++++++++++++++----------------------
 drivers/pci/hotplug/shpchp_ctrl.c  |  6 +++---
 drivers/pci/pcie/Kconfig           |  2 +-
 drivers/pci/pcie/aer/aerdrv_core.c |  1 +
 drivers/pci/pcie/aspm.c            |  3 +++
 10 files changed, 40 insertions(+), 43 deletions(-)
