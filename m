Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbbASEwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:52:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:33463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbbASEwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:52:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,424,1418112000"; 
   d="scan'208";a="672049557"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [Bugfix 0/3] Fix regressions in Xen IRQ management
Date: Mon, 19 Jan 2015 12:55:41 +0800
Message-Id: <1421643344-17092-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	Sander reports an Xen pci-passthrough regression caused by
commit cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 ("x86, irq: Keep
balance of IOAPIC pin reference count"). This patch set tries to
fix it.

Patch 1 is a fix for another issue found during fixing the regression.
Patch 2 is a hotfix for the regression and should be targeted for v3.19.
Patch 3 is the foundamental fix for the regression and should be targeted
at v3.20.

Hi Sander,
	Could you please help to test by:
1) only apply patch 1 and patch 2
2) and then apply patch 3 ontop of patch 1/2.
Thanks!
Gerry

Jiang Liu (3):
  xen/irq, ACPI: Fix regression in xen PCI passthrough caused by
    cffe0a2b5a34
  xen/irq: Override ACPI IRQ management callback __acpi_unregister_gsi
  x86/PCI: Refine the way to release PCI IRQ resources

 arch/x86/include/asm/acpi.h    |    1 +
 arch/x86/include/asm/pci_x86.h |    2 --
 arch/x86/pci/common.c          |   30 ++++++++++++++++++++++++++++--
 arch/x86/pci/intel_mid_pci.c   |    4 ++--
 arch/x86/pci/irq.c             |   15 +--------------
 arch/x86/pci/xen.c             |    2 ++
 drivers/acpi/pci_irq.c         |   10 +---------
 7 files changed, 35 insertions(+), 29 deletions(-)

-- 
1.7.10.4

