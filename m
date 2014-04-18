Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaDRPma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:42:30 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36309 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaDRPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:42:24 -0400
Date: Fri, 18 Apr 2014 09:42:20 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>, Mohit Kumar <mohit.kumar@st.com>,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [GIT PULL] PCI updates for v3.15
Message-ID: <20140418154220.GA20053@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are fixes for a powerpc NULL pointer dereference, an OF
interrupt mapping issue on some of the new host bridges, and a DesignWare
iATU issue.

Bjorn


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci-v3.15-fixes-1

for you to fetch changes up to f5d3352b2751f8de7e06e23a04ac0b4c474075e9:

  PCI: tegra: Use new OF interrupt mapping when possible (2014-04-16 10:24:32 -0600)

----------------------------------------------------------------
PCI updates for v3.15:

  Host bridge drivers
    - Fix OF interrupt mapping for DesignWare, R-Car, Tegra (Lucas Stach)
    - Fix DesignWare iATU programming (Mohit Kumar)

  Miscellaneous
    - Fix powerpc NULL dereference from list_for_each_entry() update (Mike Qiu)

----------------------------------------------------------------
Lucas Stach (3):
      PCI: designware: Use new OF interrupt mapping when possible
      PCI: rcar: Use new OF interrupt mapping when possible
      PCI: tegra: Use new OF interrupt mapping when possible

Mike Qiu (1):
      powerpc/PCI: Fix NULL dereference in sys_pciconfig_iobase() list traversal

Mohit Kumar (2):
      PCI: designware: Fix comment for setting number of lanes
      PCI: designware: Fix iATU programming for cfg1, io and mem viewport

 arch/powerpc/kernel/pci_64.c       | 10 ++++++----
 drivers/pci/host/pci-rcar-gen2.c   |  8 +++++++-
 drivers/pci/host/pci-tegra.c       |  7 ++++++-
 drivers/pci/host/pcie-designware.c | 20 +++++++++++++-------
 4 files changed, 32 insertions(+), 13 deletions(-)
