Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaFJXOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38716 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbaFJXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 04/10] tools: Add packed struct method for unaligned references
Date: Tue, 10 Jun 2014 16:13:08 -0700
Message-Id: <1402441994-16780-5-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc can generate code for unaligned references using a packed struct
on nearly all architectures.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/unaligned/be_struct.h | 60 +++++++++++++++++++++++++++++++
 tools/include/tools/unaligned/le_struct.h | 60 +++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)
 create mode 100644 tools/include/tools/unaligned/be_struct.h
 create mode 100644 tools/include/tools/unaligned/le_struct.h

diff --git a/tools/include/tools/unaligned/be_struct.h b/tools/include/tools/unaligned/be_struct.h
new file mode 100644
index 000000000000..27b73bdf5a86
--- /dev/null
+++ b/tools/include/tools/unaligned/be_struct.h
@@ -0,0 +1,60 @@
+#ifndef _TOOLS_BE_STRUCT_H
+#define _TOOLS_BE_STRUCT_H
+
+#include <stdint.h>
+
+struct _packed_u16_struct {
+	uint16_t v;
+} __attribute__((packed));
+
+struct _packed_u32_struct {
+	uint32_t v;
+} __attribute__((packed));
+
+struct _packed_u64_struct {
+	uint64_t v;
+} __attribute__((packed));
+
+static inline uint16_t get_unaligned_be16(const void *_p)
+{
+	const struct _packed_u16_struct *p = _p;
+
+	return p->v;
+}
+
+static inline uint32_t get_unaligned_be32(const void *_p)
+{
+	const struct _packed_u32_struct *p = _p;
+
+	return p->v;
+}
+
+static inline uint64_t get_unaligned_be64(const void *_p)
+{
+	const struct _packed_u64_struct *p = _p;
+
+	return p->v;
+}
+
+static inline void put_unaligned_be16(uint16_t val, void *_p)
+{
+	struct _packed_u16_struct *p = _p;
+
+	p->v = val;
+}
+
+static inline void put_unaligned_be32(uint32_t val, void *_p)
+{
+	struct _packed_u32_struct *p = _p;
+
+	p->v = val;
+}
+
+static inline void put_unaligned_be64(uint64_t val, void *_p)
+{
+	struct _packed_u64_struct *p = _p;
+
+	p->v = val;
+}
+
+#endif /* _TOOLS_BE_STRUCT_H */
diff --git a/tools/include/tools/unaligned/le_struct.h b/tools/include/tools/unaligned/le_struct.h
new file mode 100644
index 000000000000..281b03b8f316
--- /dev/null
+++ b/tools/include/tools/unaligned/le_struct.h
@@ -0,0 +1,60 @@
+#ifndef _TOOLS_LE_STRUCT_H
+#define _TOOLS_LE_STRUCT_H
+
+#include <stdint.h>
+
+struct _packed_u16_struct {
+	uint16_t v;
+} __attribute__((packed));
+
+struct _packed_u32_struct {
+	uint32_t v;
+} __attribute__((packed));
+
+struct _packed_u64_struct {
+	uint64_t v;
+} __attribute__((packed));
+
+static inline uint16_t get_unaligned_le16(const void *_p)
+{
+	const struct _packed_u16_struct *p = _p;
+
+	return p->v;
+}
+
+static inline uint32_t get_unaligned_le32(const void *_p)
+{
+	const struct _packed_u32_struct *p = _p;
+
+	return p->v;
+}
+
+static inline uint64_t get_unaligned_le64(const void *_p)
+{
+	const struct _packed_u64_struct *p = _p;
+
+	return p->v;
+}
+
+static inline void put_unaligned_le16(uint16_t val, void *_p)
+{
+	struct _packed_u16_struct *p = _p;
+
+	p->v = val;
+}
+
+static inline void put_unaligned_le32(uint32_t val, void *_p)
+{
+	struct _packed_u32_struct *p = _p;
+
+	p->v = val;
+}
+
+static inline void put_unaligned_le64(uint64_t val, void *_p)
+{
+	struct _packed_u64_struct *p = _p;
+
+	p->v = val;
+}
+
+#endif /* _TOOLS_LE_STRUCT_H */
-- 
1.9.3

