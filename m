Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3LNTb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:31:26 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:56684 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3LNTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:31:24 -0500
Date: Sat, 14 Dec 2013 12:31:20 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khalid Aziz <khalid.aziz@oracle.com>, Chang Liu <cl91tp@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Michal Marek <mmarek@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [GIT PULL] PCI updates for v3.13
Message-ID: <20131214193120.GE6746@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.13-fixes-2

for you to fetch changes up to f0b75693cbb26439ba959ba7d3b4f43e2fcf3da6:

  MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers (2013-12-11 10:40:59 -0700)

----------------------------------------------------------------
PCI updates for v3.13:

  PCI device hotplug
    - Move device_del() from pci_stop_dev() to pci_destroy_dev() (Rafael J. Wysocki)

  Host bridge drivers
    - Update maintainers for DesignWare, i.MX6, Armada, R-Car (Bjorn Helgaas)
    - mvebu: Return 'unsupported' for Interrupt Line and Interrupt Pin (Jason Gunthorpe)

  Miscellaneous
    - Avoid unnecessary CPU switch when calling .probe() (Alexander Duyck)
    - Revert "workqueue: allow work_on_cpu() to be called recursively" (Bjorn Helgaas)
    - Disable Bus Master only on kexec reboot (Khalid Aziz)
    - Omit PCI ID macro strings to shorten quirk names for LTO (Michal Marek)

 MAINTAINERS                  | 33 +++++++++++++++++++++++++++++++++
 drivers/pci/host/pci-mvebu.c |  5 +++++
 drivers/pci/pci-driver.c     | 38 ++++++++++++++++++++++++++++++--------
 drivers/pci/remove.c         |  4 +++-
 include/linux/kexec.h        |  3 +++
 include/linux/pci.h          | 30 +++++++++++++++---------------
 kernel/kexec.c               |  4 ++++
 kernel/workqueue.c           | 32 ++++++++++----------------------
 8 files changed, 103 insertions(+), 46 deletions(-)

----------------------------------------------------------------
Alexander Duyck (1):
      PCI: Avoid unnecessary CPU switch when calling driver .probe() method

Bjorn Helgaas (2):
      Revert "workqueue: allow work_on_cpu() to be called recursively"
      MAINTAINERS: Add DesignWare, i.MX6, Armada, R-Car PCI host maintainers

Jason Gunthorpe (1):
      PCI: mvebu: Return 'unsupported' for Interrupt Line and Interrupt Pin

Khalid Aziz (1):
      PCI: Disable Bus Master only on kexec reboot

Michal Marek (1):
      PCI: Omit PCI ID macro strings to shorten quirk names

Rafael J. Wysocki (1):
      PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()

 MAINTAINERS                  | 33 +++++++++++++++++++++++++++++++++
 drivers/pci/host/pci-mvebu.c |  5 +++++
 drivers/pci/pci-driver.c     | 38 ++++++++++++++++++++++++++++++--------
 drivers/pci/remove.c         |  4 +++-
 include/linux/kexec.h        |  3 +++
 include/linux/pci.h          | 30 +++++++++++++++---------------
 kernel/kexec.c               |  4 ++++
 kernel/workqueue.c           | 32 ++++++++++----------------------
 8 files changed, 103 insertions(+), 46 deletions(-)
