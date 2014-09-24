Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaIXQG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:06:59 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:59292 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaIXQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:06:56 -0400
Date: Wed, 24 Sep 2014 10:06:52 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Dirk Gouders <dirk@gouders.net>,
        David Henningsson <david.henningsson@canonical.com>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: [GIT PULL] PCI fixes for v3.17
Message-ID: <20140924160652.GA17609@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are a few fixes that should be in v3.17.

  - Reverting "Don't scan random busses" covers up a CardBus regression
    having to do with allocating CardBus bus numbers.

  - Reverting "Make sure bus numbers stay within parents bounds" covers up
    an ACPI _CRS bug that makes us reconfigure a bridge, causing a broken
    device behind it to stop responding.

  - The pciehp timeout change fixes some code we added in v3.17.  Without
    the fix, we can send a new hotplug command too early, before the
    timeout has expired.

I hope for better fixes for the reverts, but those will have to come after
v3.17.

Bjorn


The following changes since commit 649ae75286793304130e747efa7d1a88daaf7e2e:

  Merge branch 'pci/vga'; commit '6a73336bde29' into for-linus (2014-09-18 23:05:06 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.17-fixes-3

for you to fetch changes up to 7cbeb9f90db8e56856db7568520b735732d34d86:

  PCI: pciehp: Fix pcie_wait_cmd() timeout (2014-09-22 20:05:45 -0600)

----------------------------------------------------------------
PCI updates for v3.17:

  Enumeration
    - Revert "PCI: Don't scan random busses in pci_scan_bridge()" (Bjorn Helgaas)
    - Revert "PCI: Make sure bus number resources stay within their parents bounds" (Bjorn Helgaas)

  PCI device hotplug
    - Fix pciehp pcie_wait_cmd() timeout (Yinghai Lu)

----------------------------------------------------------------
Bjorn Helgaas (2):
      Revert "PCI: Don't scan random busses in pci_scan_bridge()"
      Revert "PCI: Make sure bus number resources stay within their parents bounds"

Yinghai Lu (1):
      PCI: pciehp: Fix pcie_wait_cmd() timeout

 drivers/pci/hotplug/pciehp_hpc.c |  2 +-
 drivers/pci/probe.c              | 20 +++++---------------
 2 files changed, 6 insertions(+), 16 deletions(-)
