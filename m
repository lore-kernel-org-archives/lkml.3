Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaDCTpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:45:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbaDCTpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:45:33 -0400
Message-ID: <1396554331.3215.30.camel@ul30vt.home>
Subject: [GIT PULL] VFIO update for 3.15-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Thu, 03 Apr 2014 13:45:31 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.15-rc1

for you to fetch changes up to 4379d2ae152860e023b42257fd60b5e235047f63:

  vfio: always select ANON_INODES (2014-03-27 11:58:58 -0600)

----------------------------------------------------------------
VFIO updates for v3.15 include:
- Allow the vfio-type1 IOMMU to support multiple domains within a container
- Plumb path to query whether all domains are cache-coherent
- Wire query into kvm-vfio device to avoid KVM x86 WBINVD emulation
- Always select CONFIG_ANON_INODES, vfio depends on it (Arnd)

The first patch also makes the vfio-type1 IOMMU driver completely independent
of the bus_type of the devices it's handling, which enables it to be used for
both vfio-pci and a future vfio-platform (and hopefully combinations involving
both simultaneously).

----------------------------------------------------------------
Alex Williamson (4):
      vfio/iommu_type1: Multi-IOMMU domain support
      vfio/type1: Add extension to test DMA cache coherence of IOMMU
      vfio: Add external user check extension interface
      kvm/vfio: Support for DMA coherent IOMMUs

Arnd Bergmann (1):
      vfio: always select ANON_INODES

 drivers/vfio/Kconfig            |   1 +
 drivers/vfio/vfio.c             |   6 +
 drivers/vfio/vfio_iommu_type1.c | 656 ++++++++++++++++++++++------------------
 include/linux/vfio.h            |   2 +
 include/uapi/linux/vfio.h       |   6 +
 virt/kvm/vfio.c                 |  27 +-
 6 files changed, 390 insertions(+), 308 deletions(-)


