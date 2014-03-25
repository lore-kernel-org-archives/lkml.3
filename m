Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbaCYSCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:02:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55643 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaCYRRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@linaro.org>, Sage Weil <sage@inktank.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 01/81] kernel.h: define u8, s8, u32, etc. limits
Date: Tue, 25 Mar 2014 10:15:14 -0700
Message-Id: <1395767794-5012-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <alex.elder@linaro.org>

commit 89a0714106aac7309c7dfa0f004b39e1e89d2942 upstream.

Create constants that define the maximum and minimum values
representable by the kernel types u8, s8, u16, s16, and so on.

Signed-off-by: Alex Elder <elder@linaro.org>
Cc: Sage Weil <sage@inktank.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8 stable for backport convenience ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/kernel.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c566927..8a7a12b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -29,6 +29,19 @@
 #define ULLONG_MAX	(~0ULL)
 #define SIZE_MAX	(~(size_t)0)
 
+#define U8_MAX		((u8)~0U)
+#define S8_MAX		((s8)(U8_MAX>>1))
+#define S8_MIN		((s8)(-S8_MAX - 1))
+#define U16_MAX		((u16)~0U)
+#define S16_MAX		((s16)(U16_MAX>>1))
+#define S16_MIN		((s16)(-S16_MAX - 1))
+#define U32_MAX		((u32)~0U)
+#define S32_MAX		((s32)(U32_MAX>>1))
+#define S32_MIN		((s32)(-S32_MAX - 1))
+#define U64_MAX		((u64)~0ULL)
+#define S64_MAX		((s64)(U64_MAX>>1))
+#define S64_MIN		((s64)(-S64_MAX - 1))
+
 #define STACK_MAGIC	0xdeadbeef
 
 #define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
-- 
1.8.3.2

