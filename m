Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbaCEPUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:20:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaCEOZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vinayak Kale <vkale@apm.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 043/131] ARM: 7957/1: add DSB after icache flush in __flush_icache_all()
Date: Wed,  5 Mar 2014 14:22:47 +0000
Message-Id: <1394029455-23128-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinayak Kale <vkale@apm.com>

commit 39544ac9df20f73e49fc6b9ac19ff533388c82c0 upstream.

Add DSB after icache flush to complete the cache maintenance operation.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/cacheflush.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 17d0ae8..a25e62d 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -212,6 +212,7 @@ extern void copy_to_user_page(struct vm_area_struct *, struct page *,
 static inline void __flush_icache_all(void)
 {
 	__flush_icache_preferred();
+	dsb();
 }
 
 /*
-- 
1.9.0

