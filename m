Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbaGVWXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:23:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaGVWXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 090/116] arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro
Date: Tue, 22 Jul 2014 15:21:41 -0700
Message-Id: <1406067727-19683-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
index 9947768..3699d1d 100644
--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -23,8 +23,6 @@
 
 #include <asm-generic/dma-coherent.h>
 
-#define ARCH_HAS_DMA_GET_REQUIRED_MASK
-
 extern struct dma_map_ops *dma_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
-- 
1.9.1

