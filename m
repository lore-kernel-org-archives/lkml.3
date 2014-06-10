Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaFJXOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38714 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbaFJXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 09/10] tools: Add common infrastructure for byte swapping
Date: Tue, 10 Jun 2014 16:13:13 -0700
Message-Id: <1402441994-16780-10-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common selection infrastructure for picking the best byte swap method.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/unaligned/be_swap.h | 15 +++++++++++++++
 tools/include/tools/unaligned/le_swap.h | 15 +++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 tools/include/tools/unaligned/be_swap.h
 create mode 100644 tools/include/tools/unaligned/le_swap.h

diff --git a/tools/include/tools/unaligned/be_swap.h b/tools/include/tools/unaligned/be_swap.h
new file mode 100644
index 000000000000..f0effb8fc6ca
--- /dev/null
+++ b/tools/include/tools/unaligned/be_swap.h
@@ -0,0 +1,15 @@
+#ifndef TOOLS_BE_SWAP_H
+#define TOOLS_BE_SWAP_H
+
+#ifdef htole64
+/* Prefer the <endian.h> infrastructure if it exists */
+# include <tools/unaligned/be_endian.h>
+#elif TOOLS_UNALIGNED_GCC >= 0x040800
+/* This version of gcc is new enough to have __builtin_bswap*() */
+# include <tools/unaligned/be_bswap.h>
+#else
+/* This always works */
+# include <tools/unaligned/be_byteshift.h>
+#endif
+
+#endif /* TOOLS_BE_SWAP_H */
diff --git a/tools/include/tools/unaligned/le_swap.h b/tools/include/tools/unaligned/le_swap.h
new file mode 100644
index 000000000000..8952723c1dff
--- /dev/null
+++ b/tools/include/tools/unaligned/le_swap.h
@@ -0,0 +1,15 @@
+#ifndef TOOLS_LE_SWAP_H
+#define TOOLS_LE_SWAP_H
+
+#ifdef htobe64
+/* Prefer the <endian.h> infrastructure if it exists */
+# include <tools/unaligned/le_endian.h>
+#elif TOOLS_UNALIGNED_GCC >= 0x040800
+/* This version of gcc is new enough to have __builtin_bswap*() */
+# include <tools/unaligned/le_bswap.h>
+#else
+/* This always works */
+# include <tools/unaligned/le_byteshift.h>
+#endif
+
+#endif /* TOOLS_LE_SWAP_H */
-- 
1.9.3

