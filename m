Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaBTSpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:45:46 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36284 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbaBTSpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:45:44 -0500
Date: Thu, 20 Feb 2014 11:45:38 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>, Tejun Heo <tj@kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [GIT PULL] PCI updates for v3.14
Message-ID: <20140220184538.GA8280@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The most interesting thing here is the change to enable INTx (by clearing
PCI_COMMAND_INTX_DISABLE) if the BIOS left INTx disabled.  Apparently the
Baytrail BIOS does this, which means EHCI doesn't work.

Also, fix an AHCI MSI regression and other issues with the recent MSI
changes. This also adds pci_enable_msi_exact() and pci_enable_msix_exact(),
which aren't regression fixes, but will keep us from touching drivers twice
(once to stop using the deprecated pci_enable_msi(), etc., and again to use
the *_exact() variants).

There's also a minor MVEBU fix.

Bjorn


The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.14-fixes-1

for you to fetch changes up to fc40363b2140f5777c88e67814fac9327bf1ee68:

  ahci: Fix broken fallback to single MSI mode (2014-02-14 14:27:19 -0700)

----------------------------------------------------------------
PCI updates for v3.14:

  MSI
    - Fix AHCI single-MSI fallback (Alexander Gordeev)
    - Fix populate_msi_sysfs() error paths (Greg Kroah-Hartman)
    - Fix htmldocs problem (Masanari Iida)
    - Add pci_enable_msi_exact() and pci_enable_msix_exact() (Alexander Gordeev)
    - Update documentation (Alexander Gordeev)

  Miscellaneous
    - mvebu: expose device ID & revision via lspci (Andrew Lunn)
    - Enable INTx if the BIOS left them disabled (Bjorn Helgaas)

----------------------------------------------------------------
Alexander Gordeev (4):
      PCI/MSI: Add pci_enable_msi() documentation back
      PCI/MSI: Fix cut-and-paste errors in documentation
      PCI/MSI: Add pci_enable_msi_exact() and pci_enable_msix_exact()
      ahci: Fix broken fallback to single MSI mode

Andrew Lunn (1):
      PCI: mvebu: Use Device ID and revision from underlying endpoint

Bjorn Helgaas (1):
      PCI: Enable INTx if BIOS left them disabled

Greg Kroah-Hartman (2):
      PCI/MSI: Check kmalloc() return value, fix leak of name
      PCI/MSI: Fix leak of msi_attrs

Masanari Iida (1):
      PCI/MSI: Fix pci_msix_vec_count() htmldocs failure

 Documentation/PCI/MSI-HOWTO.txt | 119 ++++++++++++++++++++++++++++++++++++----
 drivers/ata/ahci.c              |   4 +-
 drivers/pci/host/pci-mvebu.c    |  11 +---
 drivers/pci/msi.c               |  10 +++-
 drivers/pci/pci.c               |  10 ++++
 include/linux/pci.h             |  20 +++++++
 6 files changed, 152 insertions(+), 22 deletions(-)
