Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3HEUme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:42:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50967 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3HEUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:32 -0400
Message-ID: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 00/20] PCI root complex changes for tile architecture
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes add new features and fix bugs in the Tilera PCI
root complex subsystem.  Among the new tilegx features are support
for I/O space access, more MXI-X interrupt vectors, and support for
TRIO 0 MAC 0 on Gx72 systems.

Chris Metcalf (20):
  tile PCI RC: cleanups for tilepro PCI RC
  tile PCI RC: tilepro conflict with PCI and RAM addresses
  tile PCI RC: support pci=off boot arg for tilepro
  tile PCI RC: tweak the the pcie_rc_delay support
  tile PCI RC: handle case that PCI link is already up
  tile: support LSI MEGARAID SAS HBA hybrid dma_ops
  tile PCI RC: support more MSI-X interrupt vectors
  tile PCI RC: gentler warning for missing plug-in PCI
  tile PCI RC: support I/O space access
  tile PCI DMA: handle a NULL dev argument properly
  tile PCI RC: restructure TRIO initialization
  tile PCI RC: eliminate pci_controller.mem_resources field
  tile PCI RC: include pci/pcie/Kconfig
  tile PCI RC: bomb comments and whitespace format
  tile PCI RC: use proper accessor function
  tile PCI RC: add dma_get_required_mask()
  tile PCI DMA: fix bug in non-page-aligned accessors
  tile PCI RC: support PCIe TRIO 0 MAC 0 on Gx72 system
  tile PCI RC: reduce driver's vmalloc space usage
  tile PCI RC: remove stale include of linux/numa.h

 arch/tile/Kconfig                    |  12 +
 arch/tile/gxio/iorpc_trio.c          |  23 ++
 arch/tile/include/arch/trio.h        |  39 ++
 arch/tile/include/asm/dma-mapping.h  |   8 +-
 arch/tile/include/asm/io.h           | 126 ++++++-
 arch/tile/include/asm/pci.h          |  17 +-
 arch/tile/include/gxio/iorpc_trio.h  |   5 +
 arch/tile/include/hv/drv_trio_intf.h |   8 +-
 arch/tile/kernel/pci-dma.c           |  44 ++-
 arch/tile/kernel/pci.c               |  33 +-
 arch/tile/kernel/pci_gx.c            | 710 ++++++++++++++++++++---------------
 arch/tile/kernel/setup.c             |   9 +-
 12 files changed, 678 insertions(+), 356 deletions(-)

-- 
1.8.3.1

