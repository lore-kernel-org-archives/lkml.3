Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaJKH4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 03:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaJKH4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 03:56:22 -0400
Message-ID: <1413014178.4202.15.camel@ul30vt.home>
Subject: [GIT PULL] VFIO updates for 3.18-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Sat, 11 Oct 2014 01:56:18 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.18-rc1

for you to fetch changes up to 93899a679fd6b2534b5c297d9316bae039ebcbe1:

  vfio-pci: Fix remove path locking (2014-09-29 17:18:39 -0600)

----------------------------------------------------------------
VFIO updates for v3.18-rc1
 - Nested IOMMU extension to type1 (Will Deacon)
 - Restore MSIx message before enabling (Gavin Shan)
 - Fix remove path locking (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      vfio-pci: Fix remove path locking

Gavin Shan (3):
      PCI: Export MSI message relevant functions
      vfio/pci: Restore MSIx message prior to enabling
      drivers/vfio: Export vfio_spapr_iommu_eeh_ioctl() with GPL

Will Deacon (2):
      iommu: introduce domain attribute for nesting IOMMUs
      vfio/iommu_type1: add new VFIO_TYPE1_NESTING_IOMMU IOMMU type

 drivers/pci/msi.c                 |   2 +
 drivers/vfio/pci/vfio_pci.c       | 136 ++++++++++++++++----------------------
 drivers/vfio/pci/vfio_pci_intrs.c |  15 +++++
 drivers/vfio/vfio_iommu_type1.c   |  30 +++++++--
 drivers/vfio/vfio_spapr_eeh.c     |   2 +-
 include/linux/iommu.h             |   1 +
 include/uapi/linux/vfio.h         |   3 +
 7 files changed, 104 insertions(+), 85 deletions(-)

