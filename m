Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbaGCJbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:31:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030559AbaGCJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 178/198] arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro
Date: Thu,  3 Jul 2014 10:20:21 +0100
Message-Id: <1404379241-8590-179-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

commit f3a183cb422574014538017b5b291a416396f97e upstream.

Arm64 does not define dma_get_required_mask() function.
Therefore, it should not define the ARCH_HAS_DMA_GET_REQUIRED_MASK.
This causes build errors in some device drivers (e.g. mpt2sas)

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/include/asm/dma-mapping.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
index 8d1810001aef..e8d35b562e3a 100644
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

