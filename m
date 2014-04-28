Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaD1WMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:12:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:38582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaD1WMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="522615331"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/7] x86: Add C intrinsics for new rd/wr fs/gs base instructions
Date: Mon, 28 Apr 2014 15:12:37 -0700
Message-Id: <1398723161-21968-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Plus for swapgs.

Very straight forward. Used in followon patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/fsgs.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 arch/x86/include/asm/fsgs.h

diff --git a/arch/x86/include/asm/fsgs.h b/arch/x86/include/asm/fsgs.h
new file mode 100644
index 0000000..a3a5cd3
--- /dev/null
+++ b/arch/x86/include/asm/fsgs.h
@@ -0,0 +1,43 @@
+#ifndef _ASM_FSGS_H
+#define _ASM_FSGS_H 1
+
+static inline void swapgs(void)
+{
+	asm volatile("swapgs" ::: "memory");
+}
+
+/* Must be protected by X86_FEATURE_FSGSBASE check. */
+
+static inline unsigned long rdgsbase(void)
+{
+	unsigned long gs;
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xc8 # rdgsbaseq %%rax"
+			: "=a" (gs)
+			:: "memory");
+	return gs;
+}
+
+static inline unsigned long rdfsbase(void)
+{
+	unsigned long fs;
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xc0 # rdfsbaseq %%rax"
+			: "=a" (fs)
+			:: "memory");
+	return fs;
+}
+
+static inline void wrgsbase(unsigned long gs)
+{
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xd8 # wrgsbaseq %%rax"
+			:: "a" (gs)
+			: "memory");
+}
+
+static inline void wrfsbase(unsigned long fs)
+{
+	asm volatile(".byte 0xf3,0x48,0x0f,0xae,0xd0 # wrfsbaseq %%rax"
+			:: "a" (fs)
+			: "memory");
+}
+
+#endif
-- 
1.9.0

