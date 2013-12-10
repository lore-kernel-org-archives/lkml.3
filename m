Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3LJTal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:30:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58360 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3LJTaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:30:39 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 1/2] mm/ARM: dma: fix conflicting types for 'arm_dma_zone_size'
Date: Tue, 10 Dec 2013 14:29:57 -0500
Message-ID: <1386703798-26521-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386703798-26521-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386703798-26521-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Commit 364230b9 "ARM: use phys_addr_t for DMA zone sizes" changes
type of arm_dma_zone_size to phys_addr_t, but misses to update
external definition of it in in arch/arm/include/asm/dma.h.
As result, kernel build is failed if CONFIG_ZONE_DMA is enabled:

arch/arm/mm/init.c:202:13: error: conflicting types for 'arm_dma_zone_size'
include/linux/bootmem.h:258:66: note: previous declaration of 'arm_dma_zone_size' was here

Hence, fix external definition of arm_dma_zone_size.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/include/asm/dma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 58b8c6a..1439b80 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -8,7 +8,7 @@
 #define MAX_DMA_ADDRESS	0xffffffffUL
 #else
 #define MAX_DMA_ADDRESS	({ \
-	extern unsigned long arm_dma_zone_size; \
+	extern phys_addr_t arm_dma_zone_size; \
 	arm_dma_zone_size ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
-- 
1.7.9.5

