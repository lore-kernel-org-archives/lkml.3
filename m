Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaIGS7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:59:31 -0400
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:43370 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752447AbaIGS7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:59:30 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 0/3] PCI/MSI: Remove arch_msi_check_device()
Date: Sun,  7 Sep 2014 20:57:52 +0200
Message-Id: <cover.1410078503.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a cleanup effort to get rid of arch_msi_check_device() function.

I am sending v2 series, since kbuild for v1 reports compile errors on
ppc4xx and Armada 370. Still, I have not checked the fixes on these
platforms.

Changes since v1:
  - patch 1: 'pdev' undeclared compile error fixed on ppc4xx. I updated
             changelog and removed ACK from this patch in case there are
             any objections;

  - patch 2: 'struct msi_chip' has no 'check_device' error fixed on
             Armada 370 - armada_370_xp_check_msi_device() hook removed;

  - patch 3: msi_check_device() renamed to pci_msi_supported(). This is
             the very same patch I sent earlier;

Thanks!

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (3):
  patch 1 - PCI/MSI/PPC: Remove arch_msi_check_device()
  patch 2 - PCI/MSI/Armada-370-xp: Remove arch_msi_check_device()
  patch 3 - PCI/MSI: Remove arch_msi_check_device()

 arch/powerpc/include/asm/machdep.h     |  2 --
 arch/powerpc/kernel/msi.c              | 12 +--------
 arch/powerpc/platforms/cell/axon_msi.c |  9 -------
 arch/powerpc/platforms/powernv/pci.c   | 19 ++++---------
 arch/powerpc/platforms/pseries/msi.c   | 42 +++++++++++------------------
 arch/powerpc/sysdev/fsl_msi.c          | 12 +++------
 arch/powerpc/sysdev/mpic_pasemi_msi.c  | 11 ++------
 arch/powerpc/sysdev/mpic_u3msi.c       | 28 ++++++++-----------
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c  | 18 +++++--------
 arch/powerpc/sysdev/ppc4xx_msi.c       | 19 +++++--------
 drivers/irqchip/irq-armada-370-xp.c    | 14 +++-------
 drivers/pci/msi.c                      | 49 +++++++++-------------------------
 include/linux/msi.h                    |  3 ---
 13 files changed, 67 insertions(+), 171 deletions(-)

-- 
1.9.3

