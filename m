Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaC3XdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:33:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36514 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Catalin Marinas" <catalin.marinas@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Vinayak Kale" <vkale@apm.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.986599224@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 124/200] ARM: 7957/1: add DSB after icache flush in
 __flush_icache_all()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vinayak Kale <vkale@apm.com>

commit 39544ac9df20f73e49fc6b9ac19ff533388c82c0 upstream.

Add DSB after icache flush to complete the cache maintenance operation.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/cacheflush.h | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -202,6 +202,7 @@ extern void copy_to_user_page(struct vm_
 static inline void __flush_icache_all(void)
 {
 	__flush_icache_preferred();
+	dsb();
 }
 
 #define flush_cache_all()		__cpuc_flush_kern_all()

