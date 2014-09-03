Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaICVUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:41 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:50841 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 05/24] ARM64:UAPI: Set the correct __BITS_PER_LONG for ILP32
Date: Wed,  3 Sep 2014 14:18:59 -0700
Message-Id: <1409779158-30963-6-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to say to the userland API that bits per long is 32bits for ILP32.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/uapi/asm/bitsperlong.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/bitsperlong.h b/arch/arm64/include/uapi/asm/bitsperlong.h
index fce9c29..bb716d0 100644
--- a/arch/arm64/include/uapi/asm/bitsperlong.h
+++ b/arch/arm64/include/uapi/asm/bitsperlong.h
@@ -16,7 +16,14 @@
 #ifndef __ASM_BITSPERLONG_H
 #define __ASM_BITSPERLONG_H
 
-#define __BITS_PER_LONG 64
+/* Assuming __LP64__ will be defined for native ELF64's and not for ILP32. */
+#ifdef __LP64__
+# define __BITS_PER_LONG 64
+#elif defined(__ILP32__)
+# define __BITS_PER_LONG 32
+#else
+# error "Unknown ABI; not ILP32 or LP64"
+#endif
 
 #include <asm-generic/bitsperlong.h>
 
-- 
1.7.2.5

