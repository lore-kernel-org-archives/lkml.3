Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3C0Of3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:35:29 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39972 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab3C0OfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:35:24 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/3] metag: add exported <asm/ech.h> for extended context handling
Date: Wed, 27 Mar 2013 14:35:14 +0000
Message-ID: <1364394914-21257-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364394914-21257-1-git-send-email-james.hogan@imgtec.com>
References: <1364394914-21257-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_14_35_24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an exported header file <asm/ech.h> containing the definitions of
some bits which can be set in D0.8 to indicate to the kernel that
certain DSP state should be preserved. The definitions have the same
names and values as the ones in the kernel-internal <asm/tbx.h>, to
make it easier for DSP assembly code to be compatible between Linux and
non-Linux operating systems.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/uapi/asm/Kbuild |  1 +
 arch/metag/include/uapi/asm/ech.h  | 15 +++++++++++++++
 2 files changed, 16 insertions(+)
 create mode 100644 arch/metag/include/uapi/asm/ech.h

diff --git a/arch/metag/include/uapi/asm/Kbuild b/arch/metag/include/uapi/asm/Kbuild
index 876c71f..84e09fe 100644
--- a/arch/metag/include/uapi/asm/Kbuild
+++ b/arch/metag/include/uapi/asm/Kbuild
@@ -2,6 +2,7 @@
 include include/uapi/asm-generic/Kbuild.asm
 
 header-y += byteorder.h
+header-y += ech.h
 header-y += ptrace.h
 header-y += resource.h
 header-y += sigcontext.h
diff --git a/arch/metag/include/uapi/asm/ech.h b/arch/metag/include/uapi/asm/ech.h
new file mode 100644
index 0000000..ac94d1c
--- /dev/null
+++ b/arch/metag/include/uapi/asm/ech.h
@@ -0,0 +1,15 @@
+#ifndef _UAPI_METAG_ECH_H
+#define _UAPI_METAG_ECH_H
+
+/*
+ * These bits can be set in the top half of the D0.8 register when DSP context
+ * switching is enabled, in order to support partial DSP context save/restore.
+ */
+
+#define TBICTX_XEXT_BIT	0x1000	/* Enable extended context save */
+#define TBICTX_XTDP_BIT	0x0800	/* DSP accumulators/RAM/templates */
+#define TBICTX_XHL2_BIT	0x0400	/* Hardware loops */
+#define TBICTX_XAXX_BIT	0x0200	/* Extended AX registers (A*.4-7) */
+#define TBICTX_XDX8_BIT	0x0100	/* Extended DX registers (D*.8-15) */
+
+#endif /* _UAPI_METAG_ECH_H */
-- 
1.8.1.2


