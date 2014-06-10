Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaFJNJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaFJNJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:09:35 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-doc@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, iommu@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 0/3] Add pci_enable_msi_partial() to conserve MSI-related resources
Date: Tue, 10 Jun 2014 15:10:29 +0200
Message-Id: <cover.1402405331.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new pci_enable_msi_partial() interface and use it to
conserve on othewise wasted interrupt resources.

AHCI driver is the first user which would conserve on
10 out of 16 unused MSI vectors on some Intel chipsets.

Cc: linux-doc@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-s390@vger.kernel.org
Cc: x86@kernel.org
Cc: xen-devel@lists.xenproject.org
Cc: iommu@lists.linux-foundation.org
Cc: linux-ide@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (3):
  PCI/MSI: Add pci_enable_msi_partial()
  PCI/MSI/x86: Support pci_enable_msi_partial()
  AHCI: Use pci_enable_msi_partial() to conserve on 10/16 MSIs

 Documentation/PCI/MSI-HOWTO.txt |   36 ++++++++++++++--
 arch/mips/pci/msi-octeon.c      |    2 +-
 arch/powerpc/kernel/msi.c       |    4 +-
 arch/s390/pci/pci.c             |    2 +-
 arch/x86/include/asm/pci.h      |    3 +-
 arch/x86/include/asm/x86_init.h |    3 +-
 arch/x86/kernel/apic/io_apic.c  |    2 +-
 arch/x86/kernel/x86_init.c      |    4 +-
 arch/x86/pci/xen.c              |    9 +++-
 drivers/ata/ahci.c              |    4 +-
 drivers/iommu/irq_remapping.c   |   10 ++--
 drivers/pci/msi.c               |   83 ++++++++++++++++++++++++++++++++++-----
 include/linux/msi.h             |    5 +-
 include/linux/pci.h             |    3 +
 14 files changed, 134 insertions(+), 36 deletions(-)

-- 
1.7.7.6

