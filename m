Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935704Ab3BOKl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:41:59 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34302 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab3BOKlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:41:51 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/6] metag: move kick.c exports out of metag_ksyms.c
Date: Fri, 15 Feb 2013 10:41:37 +0000
Message-ID: <1360924901-21404-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
References: <1360924901-21404-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_15_10_41_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's less error prone to have function symbols exported immediately
after the function rather than in metag_ksyms.c. Move each EXPORT_SYMBOL
in metag_ksyms.c for symbols defined in kick.c into kick.c

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/kick.c        |    3 +++
 arch/metag/kernel/metag_ksyms.c |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/metag/kernel/kick.c b/arch/metag/kernel/kick.c
index c309096..50fcbec 100644
--- a/arch/metag/kernel/kick.c
+++ b/arch/metag/kernel/kick.c
@@ -25,6 +25,7 @@
  * the KICK handlers require access to a CPU's pTBI structure. So we
  * pass it as an argument.
  */
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/types.h>
@@ -48,6 +49,7 @@ void kick_register_func(struct kick_irq_handler *kh)
 
 	spin_unlock_irqrestore(&kick_handlers_lock, flags);
 }
+EXPORT_SYMBOL(kick_register_func);
 
 void kick_unregister_func(struct kick_irq_handler *kh)
 {
@@ -59,6 +61,7 @@ void kick_unregister_func(struct kick_irq_handler *kh)
 
 	spin_unlock_irqrestore(&kick_handlers_lock, flags);
 }
+EXPORT_SYMBOL(kick_unregister_func);
 
 TBIRES
 kick_handler(TBIRES State, int SigNum, int Triggers, int Inst, PTBI pTBI)
diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index 12914a4..53d437f 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -29,8 +29,6 @@ EXPORT_SYMBOL(__do_clear_user);
 
 EXPORT_SYMBOL(pTBI_get);
 EXPORT_SYMBOL(meta_memoffset);
-EXPORT_SYMBOL(kick_register_func);
-EXPORT_SYMBOL(kick_unregister_func);
 
 EXPORT_SYMBOL(clear_page);
 EXPORT_SYMBOL(copy_page);
-- 
1.7.7.6


