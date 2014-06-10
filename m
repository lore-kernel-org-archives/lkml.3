Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaFJXOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38715 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbaFJXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 03/10] tools: Add le_direct/be_direct methods for unaligned access
Date: Tue, 10 Jun 2014 16:13:07 -0700
Message-Id: <1402441994-16780-4-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For architectures which handle unaligned references transparently.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/unaligned/be_direct.h | 48 +++++++++++++++++++++++++++++++
 tools/include/tools/unaligned/le_direct.h | 48 +++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)
 create mode 100644 tools/include/tools/unaligned/be_direct.h
 create mode 100644 tools/include/tools/unaligned/le_direct.h

diff --git a/tools/include/tools/unaligned/be_direct.h b/tools/include/tools/unaligned/be_direct.h
new file mode 100644
index 000000000000..10a9b8229003
--- /dev/null
+++ b/tools/include/tools/unaligned/be_direct.h
@@ -0,0 +1,48 @@
+#ifndef _TOOLS_BE_DIRECT_H
+#define _TOOLS_BE_DIRECT_H
+
+#include <stdint.h>
+
+static inline uint16_t get_unaligned_be16(const void *_p)
+{
+	const uint16_t *p = _p;
+
+	return *p;
+}
+
+static inline uint32_t get_unaligned_be32(const void *_p)
+{
+	const uint32_t *p = _p;
+
+	return *p;
+}
+
+static inline uint64_t get_unaligned_be64(const void *_p)
+{
+	const uint64_t *p = _p;
+
+	return *p;
+}
+
+static inline void put_unaligned_be16(uint16_t val, void *_p)
+{
+	uint16_t *p = _p;
+
+	*p = val;
+}
+
+static inline void put_unaligned_be32(uint32_t val, void *_p)
+{
+	uint32_t *p = _p;
+
+	*p = val;
+}
+
+static inline void put_unaligned_be64(uint64_t val, void *_p)
+{
+	uint64_t *p = _p;
+
+	*p = val;
+}
+
+#endif /* _TOOLS_BE_DIRECT_H */
diff --git a/tools/include/tools/unaligned/le_direct.h b/tools/include/tools/unaligned/le_direct.h
new file mode 100644
index 000000000000..6353dfd04fd7
--- /dev/null
+++ b/tools/include/tools/unaligned/le_direct.h
@@ -0,0 +1,48 @@
+#ifndef _TOOLS_LE_DIRECT_H
+#define _TOOLS_LE_DIRECT_H
+
+#include <stdint.h>
+
+static inline uint16_t get_unaligned_le16(const void *_p)
+{
+	const uint16_t *p = _p;
+
+	return *p;
+}
+
+static inline uint32_t get_unaligned_le32(const void *_p)
+{
+	const uint32_t *p = _p;
+
+	return *p;
+}
+
+static inline uint64_t get_unaligned_le64(const void *_p)
+{
+	const uint64_t *p = _p;
+
+	return *p;
+}
+
+static inline void put_unaligned_le16(uint16_t val, void *_p)
+{
+	uint16_t *p = _p;
+
+	*p = val;
+}
+
+static inline void put_unaligned_le32(uint32_t val, void *_p)
+{
+	uint32_t *p = _p;
+
+	*p = val;
+}
+
+static inline void put_unaligned_le64(uint64_t val, void *_p)
+{
+	uint64_t *p = _p;
+
+	*p = val;
+}
+
+#endif /* _TOOLS_LE_DIRECT_H */
-- 
1.9.3

