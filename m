Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbaIWWvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:51:09 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35020 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbaIWWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:51:07 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, sudeep.dutt@intel.com, nikhil.rao@intel.com,
        ashutosh.dixit@intel.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] tools: add more endian.h macros
Date: Tue, 23 Sep 2014 18:50:53 -0400
Message-Id: <1411512653-17093-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some more macros to tools/endian.h to allow mpssd to be compiled
against glibc < 2.9.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Cc: rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org
Cc: sudeep.dutt@intel.com
Cc: nikhil.rao@intel.com
Cc: ashutosh.dixit@intel.com
Cc: akpm@linux-foundation.org
Cc: gregkh@linuxfoundation.org
---
 tools/include/tools/endian.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/include/tools/endian.h b/tools/include/tools/endian.h
index 5d42e20..8001194 100644
--- a/tools/include/tools/endian.h
+++ b/tools/include/tools/endian.h
@@ -15,6 +15,18 @@
 #define htole64(x) (x)
 #endif
 
+#ifndef le16toh
+#define le16toh(x) (x)
+#endif
+
+#ifndef le32toh
+#define le32toh(x) (x)
+#endif
+
+#ifndef le64toh
+#define le64toh(x) (x)
+#endif
+
 #else /* __BYTE_ORDER */
 
 #ifndef htole16
@@ -27,6 +39,18 @@
 #define htole64(x) __bswap_64(x)
 #endif
 
+#ifndef le16toh
+#define le16toh(x) __bswap_16(x)
+#endif
+
+#ifndef le32toh
+#define le32toh(x) __bswap_32(x)
+#endif
+
+#ifndef le64toh
+#define le64toh(x) __bswap_64(x)
+#endif
+
 #endif
 
 #endif /* _TOOLS_ENDIAN_H */
-- 
2.1.1

