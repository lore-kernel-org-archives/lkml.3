Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbaFQRHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099AbaFQRHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:07:41 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: remove define of ARCH_HAS_DMA_GET_REQUIRED_MASK
Date: Tue, 17 Jun 2014 13:07:03 -0400
Message-Id: <1403024823-2180-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arm64 defines ARCH_HAS_DMA_GET_REQUIRED_MASK but provides
no dma_get_required_mask() function. This leads to a link
error in drivers using dma_get_required_mask(). Remove the
define so the default dma_get_required_mask() is available.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/include/asm/dma-mapping.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 3a4572e..dc82e52 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -26,8 +26,6 @@
 #include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 
-#define ARCH_HAS_DMA_GET_REQUIRED_MASK
-
 #define DMA_ERROR_CODE	(~(dma_addr_t)0)
 extern struct dma_map_ops *dma_ops;
 extern struct dma_map_ops coherent_swiotlb_dma_ops;
-- 
1.9.0

