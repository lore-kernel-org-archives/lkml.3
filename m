Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbaGOVyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:54:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbaGOViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 157/198] arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro
Date: Tue, 15 Jul 2014 14:30:27 -0700
Message-Id: <1405459868-15089-158-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

commit f3a183cb422574014538017b5b291a416396f97e upstream.

Arm64 does not define dma_get_required_mask() function.
Therefore, it should not define the ARCH_HAS_DMA_GET_REQUIRED_MASK.
This causes build errors in some device drivers (e.g. mpt2sas)

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/dma-mapping.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index fd0c0c0..064d352 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -26,8 +26,6 @@
 #include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 
-#define ARCH_HAS_DMA_GET_REQUIRED_MASK
-
 #define DMA_ERROR_CODE	(~(dma_addr_t)0)
 extern struct dma_map_ops *dma_ops;
 
-- 
1.9.1

