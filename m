Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaI3BgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:36:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54432 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaI3BgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:36:22 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 1/5] ARM: include missing cp15.h header
Date: Mon, 29 Sep 2014 18:35:26 -0700
Message-Id: <1412040930-16864-2-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
References: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of this commit:

  commit 39792c7cf3111d69dc4aa0923859d8b929e9039f
  ARM: 7861/1: cacheflush: consolidate single-CPU ARMv7 cache disabling code

cacheflush.h now utilizes the CR_C macro from cp15.h. Let's include it.

This also means several users of v7_exit_coherency_flush() no longer
have to include cp15.h directly when they don't directly use any #defines
from it.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 arch/arm/include/asm/cacheflush.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 79ecb4f34ffb..866e229d3129 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -16,6 +16,7 @@
 #include <asm/shmparam.h>
 #include <asm/cachetype.h>
 #include <asm/outercache.h>
+#include <asm/cp15.h>
 
 #define CACHE_COLOUR(vaddr)	((vaddr & (SHMLBA - 1)) >> PAGE_SHIFT)
 
-- 
1.9.1

