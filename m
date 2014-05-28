Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaE1A1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:27:52 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:35820 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaE1A1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:27:50 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Cody P Schafer <dev@codyps.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [PATCH 11/16] byteorder: provide a linux/byteorder.h with {be,le}_to_cpu() and cpu_to_{be,le}() macros
Date: Tue, 27 May 2014 17:22:06 -0700
Message-Id: <1401236684-10579-12-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401236684-10579-1-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather manually specifying the size of the integer to be converted, key
off of the type size. Reduces duplicate size info and the occurance of
certain types of bugs (using the wrong sized conversion).

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 include/linux/byteorder.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 include/linux/byteorder.h

diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
new file mode 100644
index 0000000..c7ab8da
--- /dev/null
+++ b/include/linux/byteorder.h
@@ -0,0 +1,34 @@
+#ifndef LINUX_BYTEORDER_H_
+#define LINUX_BYTEORDER_H_
+
+#include <asm/byteorder.h>
+
+#define be_to_cpu(v) \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
+	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), be16_to_cpu(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), be32_to_cpu(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), be64_to_cpu(v), \
+		(void)0))))
+
+#define le_to_cpu(v) \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
+	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), le16_to_cpu(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), le32_to_cpu(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), le64_to_cpu(v), \
+		(void)0))))
+
+#define cpu_to_le(v) \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
+	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), cpu_to_le16(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), cpu_to_le32(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), cpu_to_le64(v), \
+		(void)0))))
+
+#define cpu_to_be(v) \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v,	\
+	__builtin_choose_expr(sizeof(v) == sizeof(uint16_t), cpu_to_be16(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint32_t), cpu_to_be32(v), \
+	__builtin_choose_expr(sizeof(v) == sizeof(uint64_t), cpu_to_be64(v), \
+		(void)0))))
+
+#endif
-- 
1.9.3

