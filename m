Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbaEEW0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:26:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbaEEW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:26:05 -0400
Date: Mon, 5 May 2014 15:25:52 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-2b6f2e649f7376d9871df63a9aa0b41efd464d74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <946c104e40c47319f8ab406e54118799cb55bd99.1399317206.git.luto@amacapital.net>
References: <946c104e40c47319f8ab406e54118799cb55bd99.1399317206.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Remove vestiges of VDSO_PRELINK and some outdated comments
Git-Commit-ID: 2b6f2e649f7376d9871df63a9aa0b41efd464d74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b6f2e649f7376d9871df63a9aa0b41efd464d74
Gitweb:     http://git.kernel.org/tip/2b6f2e649f7376d9871df63a9aa0b41efd464d74
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 5 May 2014 12:19:37 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 May 2014 13:19:07 -0700

x86, vdso: Remove vestiges of VDSO_PRELINK and some outdated comments

These definitions had no effect.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/946c104e40c47319f8ab406e54118799cb55bd99.1399317206.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
