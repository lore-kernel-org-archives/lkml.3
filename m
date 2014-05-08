Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaEHUsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:48:46 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:64527 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaEHUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:48:44 -0400
Subject: [PATCH v3 0/4] Clean up DMA API docs and dma_addr_t usage
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Thu, 08 May 2014 14:48:47 -0600
Message-ID: <20140508204257.17877.4639.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe the third time's a charm :)

This cleans up some DMA-API documentation and makes a minor no-op change to
the dma_declare_coherent_memory() prototype.

Changes from v2:
  - Added description of CPU virtual/physical and bus addresses in
    DMA-API-HOWTO
  - Added comments to sh/PCI (Dreamcast) update
  - Dropped IOMMU interface dma_addr_t changes

I didn't add Arnd's and Greg's acks to patch 1 because of all the new
address description text I added.

---

Bjorn Helgaas (4):
      DMA-API: Clarify physical/bus address distinction
      DMA-API: Change dma_declare_coherent_memory() CPU address to phys_addr_t
      sh/PCI: Pass GAPSPCI_DMA_BASE CPU & bus address to dma_declare_coherent_memory()
      iommu/exynos: Remove unnecessary "&" from function pointers


 Documentation/DMA-API-HOWTO.txt        |  192 +++++++++++++++++++++-----------
 Documentation/DMA-API.txt              |  148 +++++++++++++------------
 Documentation/DMA-ISA-LPC.txt          |    4 -
 arch/sh/drivers/pci/fixups-dreamcast.c |   18 +++
 drivers/base/dma-coherent.c            |   10 +-
 drivers/base/dma-mapping.c             |    6 +
 drivers/iommu/exynos-iommu.c           |   14 +-
 include/asm-generic/dma-coherent.h     |   13 +-
 include/linux/dma-mapping.h            |   13 ++
 include/linux/types.h                  |    1 
 10 files changed, 247 insertions(+), 172 deletions(-)

-- 
Signature
