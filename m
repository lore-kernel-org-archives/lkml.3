Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3IENmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3IENmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:42:38 -0400
Date: Thu, 5 Sep 2013 14:51:39 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 0/6] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <cover.1378383792.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is aimed to conserve on othewise wasted interrupt
resources for 10 of 16 unused MSI vectors for AHCI devices on
Intel chipsets.

Changes from v1:
	- roundup_pow_of_two() and is_power_of_2() functions used
	- patch 2/6 generic pci_get_msi_cap() interface introduced
	- patch 4/6 MMC reg. value used to initialize multiple MSIs;
		    Fallback to single MSI mode is simplified
	- patch 5/6 sanity check for MRSM bit added

Alexander Gordeev (6):
  1/6 PCI/MSI: Introduce pci_enable_msi_block_part() interface
  2/6 PCI/MSI: Factor out pci_get_msi_cap() interface
  3/6 MSI/x86: Support pci_enable_msi_block_part() interface
  4/6 AHCI: Conserve interrupts with pci_enable_msi_block_part() interface
  5/6 AHCI: Check MRSM bit when multiple MSIs enabled
  6/6 PCI/MSI: Get rid of pci_enable_msi_block_auto() interface

 Documentation/PCI/MSI-HOWTO.txt |   68 ++++++++++++++++-------
 arch/mips/pci/msi-octeon.c      |    2 +-
 arch/powerpc/kernel/msi.c       |    4 +-
 arch/s390/pci/pci.c             |    2 +-
 arch/x86/include/asm/pci.h      |    8 ++-
 arch/x86/include/asm/x86_init.h |    3 +-
 arch/x86/kernel/apic/io_apic.c  |    3 +-
 drivers/ata/ahci.c              |   60 ++++++++++++++------
 drivers/ata/ahci.h              |    1 +
 drivers/iommu/irq_remapping.c   |   14 +++---
 drivers/pci/msi.c               |  115 ++++++++++++++++++++++-----------------
 include/linux/msi.h             |    5 +-
 include/linux/pci.h             |   13 ++++-
 13 files changed, 188 insertions(+), 110 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
