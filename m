Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaICVUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:43 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37865 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 04/24] ARM64:ILP32: Set kernel_long to long long so we can reuse most of the same syscalls as LP64
Date: Wed,  3 Sep 2014 14:18:58 -0700
Message-Id: <1409779158-30963-5-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we want time_t and some other userland types to be the same between ILP32 and LP64, we define __kernel_long_t to be long long.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/uapi/asm/posix_types.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/posix_types.h b/arch/arm64/include/uapi/asm/posix_types.h
index 7985ff6..0961945 100644
--- a/arch/arm64/include/uapi/asm/posix_types.h
+++ b/arch/arm64/include/uapi/asm/posix_types.h
@@ -5,6 +5,12 @@ typedef unsigned short __kernel_old_uid_t;
 typedef unsigned short __kernel_old_gid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
 
+#ifdef __ILP32__
+typedef long long __kernel_long_t;
+typedef unsigned long long __kernel_ulong_t;
+#define __kernel_long_t __kernel_long_t
+#endif
+
 #include <asm-generic/posix_types.h>
 
-#endif /*  __ASM_POSIX_TYPES_H */
+#endif /* __ASM_POSIX_TYPES_H */
-- 
1.7.2.5

