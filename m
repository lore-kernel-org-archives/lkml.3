Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaAHL0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:26:49 -0500
Received: from smtp-69.nebula.fi ([83.145.220.69]:35732 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbaAHL0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:26:46 -0500
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] openrisc: head: use THREAD_SIZE instead of magic constant
Date: Wed,  8 Jan 2014 13:26:04 +0200
Message-Id: <1389180364-4844-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/kernel/head.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index eecc8df..0c21acd 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -24,6 +24,7 @@
 #include <asm/page.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
+#include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/spr_defs.h>
 #include <asm/asm-offsets.h>
@@ -486,7 +487,8 @@ _start:
 	/*
 	 * set up initial ksp and current
 	 */
-	LOAD_SYMBOL_2_GPR(r1,init_thread_union+0x2000)	// setup kernel stack
+	/* setup kernel stack */
+	LOAD_SYMBOL_2_GPR(r1,init_thread_union + THREAD_SIZE)
 	LOAD_SYMBOL_2_GPR(r10,init_thread_union)	// setup current
 	tophys	(r31,r10)
 	l.sw	TI_KSP(r31), r1
-- 
1.8.3.2

