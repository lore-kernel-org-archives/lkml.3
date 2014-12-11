Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbaLKME3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:04:29 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59801 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaLKME1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:04:27 -0500
Message-ID: <54898841.3060108@cantab.net>
Date: Thu, 11 Dec 2014 12:04:17 +0000
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: xen-devel <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <Boris.Ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] xen: features and fixes for 3.19-rc0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.19-rc0-tag

xen: features and fixes for 3.19-rc0

- - Fully support non-coherent devices on ARM by introducing the
  mechanisms to request the hypervisor to perform the required cache
  maintainance operations.

- - A number of pciback bug fixes and cleanups.  Notably a deadlock fix
  if a PCI device was manually uunbound and a fix for incorrectly
  restoring state after a function reset.

- - In x86 PVHVM guests, use the APIC for interrupts if this has been
  virtualized by the hardware.  This reduces the number of interrupt-
  related VM exits on such hardware.

Thanks.

David

 arch/arm/include/asm/device.h              |    1 +
 arch/arm/include/asm/dma-mapping.h         |    7 +
 arch/arm/include/asm/xen/page-coherent.h   |   66 +++++++--
 arch/arm/include/asm/xen/page.h            |    4 +
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/enlighten.c                   |    5 -
 arch/arm/xen/mm.c                          |  121 +++++++++++++++++
 arch/arm/xen/mm32.c                        |  202 ----------------------------
 arch/arm64/include/asm/device.h            |    1 +
 arch/arm64/include/asm/dma-mapping.h       |    7 +
 arch/arm64/include/asm/xen/page-coherent.h |   44 +-----
 arch/x86/include/asm/xen/cpuid.h           |   91 +++++++++++++
 arch/x86/include/asm/xen/page-coherent.h   |    4 +-
 arch/x86/include/asm/xen/page.h            |    7 +
 arch/x86/pci/xen.c                         |   31 ++++-
 drivers/pci/pci.c                          |    5 +-
 drivers/xen/swiotlb-xen.c                  |   19 +--
 drivers/xen/xen-pciback/passthrough.c      |   14 +-
 drivers/xen/xen-pciback/pci_stub.c         |  112 ++++++++++++---
 drivers/xen/xen-pciback/pciback.h          |    7 +-
 drivers/xen/xen-pciback/vpci.c             |   14 +-
 drivers/xen/xen-pciback/xenbus.c           |    4 +-
 include/linux/device.h                     |    5 +
 include/linux/pci.h                        |    2 +
 include/xen/interface/features.h           |    3 -
 include/xen/interface/grant_table.h        |   19 +++
 26 files changed, 488 insertions(+), 309 deletions(-)

Boris Ostrovsky (2):
      xen/pci: Defer initialization of MSI ops on HVM guests
      xen/pci: Use APIC directly when APIC virtualization hardware is available

David Vrabel (1):
      Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"

Jan Beulich (1):
      xen-pciback: drop SR-IOV VFs when PF driver unloads

Konrad Rzeszutek Wilk (7):
      xen/pciback: Don't deadlock when unbinding.
      driver core: Provide an wrapper around the mutex to do lockdep warnings
      xen/pciback: Include the domain id if removing the device whilst still in use
      xen/pciback: Print out the domain owning the device.
      xen/pciback: Remove tons of dereferences
      PCI: Expose pci_load_saved_state for public consumption.
      xen/pciback: Restore configuration space when detaching from a guest.

Stefano Stabellini (15):
      xen/arm: remove handling of XENFEAT_grant_map_identity
      xen/arm: remove outer_*_range call
      xen/arm: if(pfn_valid(pfn)) call native dma_ops
      arm64: introduce is_device_dma_coherent
      arm: introduce is_device_dma_coherent
      xen/arm: use is_device_dma_coherent
      xen: add a dma_addr_t dev_addr argument to xen_dma_map_page
      xen/arm: use hypercall to flush caches in map_page
      xen/arm/arm64: merge xen/mm32.c into xen/mm.c
      xen/arm/arm64: introduce xen_arch_need_swiotlb
      xen/arm: introduce GNTTABOP_cache_flush
      swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_single_for_cpu
      swiotlb-xen: remove BUG_ON in xen_bus_to_phys
      swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
      swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJUiYhAAAoJEFxbo/MsZsTRJTkIAIi9zrj7029PkxggyEAZHvVO
0XGwMGwXei6n8ofQFkFYEc5/3Df9JW7v05uqy2Y4bu+ifMvDa1C6R4tk5ol4bM4E
sgs96yMiOSRwrVD9SgE73bW84i/Xa87LCpBoCi7417j1h+6e9oQ2l4+XiWTySSne
N8/m/1QuD+6argsf2LN/a1XG1V9OInm8k9oGMM1prDwWN7JsZeaLyY3LSFXb6s2S
o6KQmUiAa66WALCFkeatocq5+PZ5PXMndweo064Zyjfuj2pYdxeGkqmWQrA1IeY4
wp2YP+XFrU36MPXD88VR9do9ovlxFCJG6tO0IWYcW8tiY+y4Rw2b+4C/oe4lm9U=
=zcCQ
-----END PGP SIGNATURE-----
