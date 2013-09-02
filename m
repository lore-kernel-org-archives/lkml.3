Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3IBI5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab3IBI5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:57:12 -0400
Date: Mon, 2 Sep 2013 10:59:07 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <cover.1378111919.git.agordeev@redhat.com>
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

Alexander Gordeev (4):
  PCI/MSI: Introduce pci_enable_msi_block_part() interface
  MSI/x86: Support pci_enable_msi_block_part() interface
  AHCI: Conserve interrupts with pci_enable_msi_block_part() interface
  PCI/MSI: Get rid of pci_enable_msi_block_auto() interface

 Documentation/PCI/MSI-HOWTO.txt |   46 +++++++++++++++++-
 arch/mips/pci/msi-octeon.c      |    2 +-
 arch/powerpc/kernel/msi.c       |    4 +-
 arch/s390/pci/pci.c             |    2 +-
 arch/x86/include/asm/pci.h      |    8 ++-
 arch/x86/include/asm/x86_init.h |    3 +-
 arch/x86/kernel/apic/io_apic.c  |    3 +-
 drivers/ata/ahci.c              |   48 +++++++++++--------
 drivers/iommu/irq_remapping.c   |   14 +++---
 drivers/pci/msi.c               |   98 ++++++++++++++++++++-------------------
 include/linux/msi.h             |    5 +-
 include/linux/pci.h             |    9 ++--
 12 files changed, 150 insertions(+), 92 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
