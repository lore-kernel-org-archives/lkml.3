Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaICVUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:39 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54688 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 11/24] ARM64: Add is_ilp32_compat_task and is_ilp32_compat_thread
Date: Wed,  3 Sep 2014 14:19:05 -0700
Message-Id: <1409779158-30963-12-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions which returns if the current task is an
ILP32 task and one returns if the thread is an ILP32 thread.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/compat.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 8fcfb29..9082b27 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -332,5 +332,27 @@ static inline int is_a32_compat_thread(struct thread_info *thread)
 }
 #endif
 
+#ifdef CONFIG_ARM64_ILP32
+static inline int is_ilp32_compat_task(void)
+{
+	return test_thread_flag(TIF_32BIT) && !is_a32_compat_task();
+}
+static inline int is_ilp32_compat_thread(struct thread_info *thread)
+{
+	return test_ti_thread_flag(thread, TIF_32BIT) &&
+	       !is_a32_compat_thread(thread);
+}
+#else
+static inline int is_ilp32_compat_task(void)
+{
+	return 0;
+}
+static inline int is_ilp32_compat_thread(struct thread_info *thread)
+{
+	return 0;
+}
+#endif
+
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_COMPAT_H */
-- 
1.7.2.5

