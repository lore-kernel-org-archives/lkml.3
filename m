Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaFJXOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38717 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaFJXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:13:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RFC 06/10] tools: Add gcc __builtin_bswap*() support for unaligned references
Date: Tue, 10 Jun 2014 16:13:10 -0700
Message-Id: <1402441994-16780-7-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402441994-16780-1-git-send-email-hpa@zytor.com>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for gcc __builtin_bswap*() for byteswapping unaligned
references.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 tools/include/tools/unaligned/be_bswap.h | 36 ++++++++++++++++++++++++++++++++
 tools/include/tools/unaligned/le_bswap.h | 36 ++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)
 create mode 100644 tools/include/tools/unaligned/be_bswap.h
 create mode 100644 tools/include/tools/unaligned/le_bswap.h

diff --git a/tools/include/tools/unaligned/be_bswap.h b/tools/include/tools/unaligned/be_bswap.h
new file mode 100644
index 000000000000..9e8d1e91fe0e
--- /dev/null
+++ b/tools/include/tools/unaligned/be_bswap.h
@@ -0,0 +1,36 @@
+#ifndef _TOOLS_BE_BSWAP_H
+#define _TOOLS_BE_BSWAP_H
+
+#include <stdint.h>
+
+static inline uint16_t get_unaligned_be16(const void *_p)
+{
+	return __builtin_bswap16(get_unaligned_le16(_p));
+}
+
+static inline uint32_t get_unaligned_be32(const void *_p)
+{
+	return __builtin_bswap32(get_unaligned_le32(_p));
+}
+
+static inline uint64_t get_unaligned_be64(const void *_p)
+{
+	return __builtin_bswap64(get_unaligned_le64(_p));
+}
+
+static inline void put_unaligned_be16(uint16_t val, void *_p)
+{
+	put_unaligned_le16(__builtin_bswap16(val), _p);
+}
+
+static inline void put_unaligned_be32(uint32_t val, void *_p)
+{
+	put_unaligned_le32(__builtin_bswap32(val), _p);
+}
+
+static inline void put_unaligned_be64(uint64_t val, void *_p)
+{
+	put_unaligned_le64(__builtin_bswap64(val), _p);
+}
+
+#endif /* _TOOLS_BE_BSWAP_H */
diff --git a/tools/include/tools/unaligned/le_bswap.h b/tools/include/tools/unaligned/le_bswap.h
new file mode 100644
index 000000000000..9c70415fa782
--- /dev/null
+++ b/tools/include/tools/unaligned/le_bswap.h
@@ -0,0 +1,36 @@
+#ifndef _TOOLS_LE_BSWAP_H
+#define _TOOLS_LE_BSWAP_H
+
+#include <stdint.h>
+
+static inline uint16_t get_unaligned_le16(const void *_p)
+{
+	return __builtin_bswap16(get_unaligned_be16(_p));
+}
+
+static inline uint32_t get_unaligned_le32(const void *_p)
+{
+	return __builtin_bswap32(get_unaligned_be32(_p));
+}
+
+static inline uint64_t get_unaligned_le64(const void *_p)
+{
+	return __builtin_bswap64(get_unaligned_be64(_p));
+}
+
+static inline void put_unaligned_le16(uint16_t val, void *_p)
+{
+	put_unaligned_be16(__builtin_bswap16(val), _p);
+}
+
+static inline void put_unaligned_le32(uint32_t val, void *_p)
+{
+	put_unaligned_be32(__builtin_bswap32(val), _p);
+}
+
+static inline void put_unaligned_le64(uint64_t val, void *_p)
+{
+	put_unaligned_be64(__builtin_bswap64(val), _p);
+}
+
+#endif /* _TOOLS_LE_BSWAP_H */
-- 
1.9.3

