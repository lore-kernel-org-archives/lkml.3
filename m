Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaKKMEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:04:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57228 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbaKKLJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vineet Gupta <vgupta@synopsys.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 029/170] ARC: unbork FPU save/restore
Date: Tue, 11 Nov 2014 11:06:28 +0000
Message-Id: <1415704129-12709-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 52e9bae93802bd29c33be11e9e758ad7daac805f upstream.

Fixes: 2ab402dfd65d15a4b2 "ARC: make start_thread() out-of-line"
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arc/include/asm/arcregs.h   | 8 --------
 arch/arc/include/asm/processor.h | 9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index 355cb470c2a4..1e4842e5305d 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -191,14 +191,6 @@
 #define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
 #define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
 
-#ifdef CONFIG_ARC_FPU_SAVE_RESTORE
-/* These DPFP regs need to be saved/restored across ctx-sw */
-struct arc_fpu {
-	struct {
-		unsigned int l, h;
-	} aux_dpfp[2];
-};
-#endif
 
 /*
  ***************************************************************
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index d99f9b37cd15..c6468fe847e3 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -20,6 +20,15 @@
 
 #include <asm/ptrace.h>
 
+#ifdef CONFIG_ARC_FPU_SAVE_RESTORE
+/* These DPFP regs need to be saved/restored across ctx-sw */
+struct arc_fpu {
+	struct {
+		unsigned int l, h;
+	} aux_dpfp[2];
+};
+#endif
+
 /* Arch specific stuff which needs to be saved per task.
  * However these items are not so important so as to earn a place in
  * struct thread_info
-- 
2.1.0

