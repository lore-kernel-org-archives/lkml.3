Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3K2Ow1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:52:27 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52858 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3K2Ow0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:52:26 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH 0/2] extend support for CMA CMA on x86
Date: Fri, 29 Nov 2013 23:51:44 +0900
Message-Id: <1385736706-3147-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set extends support for the DMA Contiguous Memory Allocator
on x86.  Currently it is only supported on pci-nommu.  So this aims at
enabling it on swiotlb and intel-iommu, too.

Regardless of which dma mapping implementation is actually used in the
system, I would like to allocate big contiguous memory with
dma_alloc_coherent() and tell the base address to the device that
requires it.  This is why I need this change.

Akinobu Mita (2):
  x86: enable DMA CMA with swiotlb
  intel-iommu: integrate DMA CMA

 arch/x86/Kconfig               |  2 +-
 arch/x86/include/asm/swiotlb.h |  7 +++++++
 arch/x86/kernel/amd_gart_64.c  |  2 +-
 arch/x86/kernel/pci-swiotlb.c  |  9 ++++++---
 arch/x86/pci/sta2x11-fixup.c   |  6 ++----
 drivers/iommu/intel-iommu.c    | 32 ++++++++++++++++++++++++--------
 include/linux/swiotlb.h        |  2 ++
 lib/swiotlb.c                  |  2 +-
 8 files changed, 44 insertions(+), 18 deletions(-)

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org
-- 
1.8.3.2

