Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaEBUQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:16:35 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36355 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaEBUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:16:07 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 6/6] x86: Remove vestiges of VDSO_PRELINK and some outdated comments
Date: Fri,  2 May 2014 13:15:48 -0700
Message-Id: <68f452d924ea09f99198078dc461425656a8251d.1399061075.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These definitions had no effect.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso.lds.S          | 7 +------
 arch/x86/vdso/vdso32/vdso32.lds.S | 5 +----
 arch/x86/vdso/vdsox32.lds.S       | 7 +------
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index b96b267..75e3404 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -1,14 +1,11 @@
 /*
  * Linker script for 64-bit vDSO.
  * We #include the file to define the layout details.
- * Here we only choose the prelinked virtual address.
  *
  * This file defines the version script giving the user-exported symbols in
- * the DSO.  We can define local symbols here called VDSO* to make their
- * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ * the DSO.
  */
 
-#define VDSO_PRELINK 0xffffffffff700000
 #include "vdso-layout.lds.S"
 
 /*
@@ -28,5 +25,3 @@ VERSION {
 	local: *;
 	};
 }
-
-VDSO64_PRELINK = VDSO_PRELINK;
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index f072095..31056cf 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -1,17 +1,14 @@
 /*
  * Linker script for 32-bit vDSO.
  * We #include the file to define the layout details.
- * Here we only choose the prelinked virtual address.
  *
  * This file defines the version script giving the user-exported symbols in
- * the DSO.  We can define local symbols here called VDSO* to make their
- * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ * the DSO.
  */
 
 #include <asm/page.h>
 
 #define BUILD_VDSO32
-#define VDSO_PRELINK 0
 
 #include "../vdso-layout.lds.S"
 
diff --git a/arch/x86/vdso/vdsox32.lds.S b/arch/x86/vdso/vdsox32.lds.S
index 62272aa..46b991b 100644
--- a/arch/x86/vdso/vdsox32.lds.S
+++ b/arch/x86/vdso/vdsox32.lds.S
@@ -1,14 +1,11 @@
 /*
  * Linker script for x32 vDSO.
  * We #include the file to define the layout details.
- * Here we only choose the prelinked virtual address.
  *
  * This file defines the version script giving the user-exported symbols in
- * the DSO.  We can define local symbols here called VDSO* to make their
- * values visible using the asm-x86/vdso.h macros from the kernel proper.
+ * the DSO.
  */
 
-#define VDSO_PRELINK 0
 #include "vdso-layout.lds.S"
 
 /*
@@ -24,5 +21,3 @@ VERSION {
 	local: *;
 	};
 }
-
-VDSOX32_PRELINK = VDSO_PRELINK;
-- 
1.9.0

