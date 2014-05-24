Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaEXHFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:05:38 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48922 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaEXHCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:24 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 05/24] ARM64:UAPI: Set the correct __BITS_PER_LONG for ILP32.
Date: Sat, 24 May 2014 00:02:00 -0700
Message-Id: <1400914939-9708-6-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to say to the userland API that bits per long is 32bits for ILP32.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/uapi/asm/bitsperlong.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/bitsperlong.h b/arch/arm64/include/uapi/asm/bitsperlong.h
index fce9c29..5e06c59 100644
--- a/arch/arm64/include/uapi/asm/bitsperlong.h
+++ b/arch/arm64/include/uapi/asm/bitsperlong.h
@@ -16,7 +16,12 @@
 #ifndef __ASM_BITSPERLONG_H
 #define __ASM_BITSPERLONG_H
 
-#define __BITS_PER_LONG 64
+/* Assuming __LP64__ will be defined for native ELF64's and not for ILP32. */
+#ifdef __LP64__
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif
 
 #include <asm-generic/bitsperlong.h>
 
-- 
1.7.2.5

