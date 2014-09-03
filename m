Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbaICXbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:31:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560AbaICWIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.14 23/88] ARM: 8097/1: unistd.h: relocate comments back to place
Date: Wed,  3 Sep 2014 15:04:57 -0700
Message-Id: <20140903220516.647121300@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit bc994c77ce82576209dcf08f71de9ae51b0b100f upstream.

Commit cb8db5d45 (UAPI: (Scripted) Disintegrate arch/arm/include/asm) moved
these syscall comments out of their context into the UAPI headers. Fix this.

Fixes: cb8db5d4578a ("UAPI: (Scripted) Disintegrate arch/arm/include/asm")

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/unistd.h      |   10 ++++++++++
 arch/arm/include/uapi/asm/unistd.h |   11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -15,7 +15,17 @@
 
 #include <uapi/asm/unistd.h>
 
+/*
+ * This may need to be greater than __NR_last_syscall+1 in order to
+ * account for the padding in the syscall table
+ */
 #define __NR_syscalls  (384)
+
+/*
+ * *NOTE*: This is a ghost syscall private to the kernel.  Only the
+ * __kuser_cmpxchg code in entry-armv.S should be aware of its
+ * existence.  Don't ever use this from user code.
+ */
 #define __ARM_NR_cmpxchg		(__ARM_NR_BASE+0x00fff0)
 
 #define __ARCH_WANT_STAT64
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -410,11 +410,6 @@
 #define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
 
 /*
- * This may need to be greater than __NR_last_syscall+1 in order to
- * account for the padding in the syscall table
- */
-
-/*
  * The following SWIs are ARM private.
  */
 #define __ARM_NR_BASE			(__NR_SYSCALL_BASE+0x0f0000)
@@ -425,12 +420,6 @@
 #define __ARM_NR_set_tls		(__ARM_NR_BASE+5)
 
 /*
- * *NOTE*: This is a ghost syscall private to the kernel.  Only the
- * __kuser_cmpxchg code in entry-armv.S should be aware of its
- * existence.  Don't ever use this from user code.
- */
-
-/*
  * The following syscalls are obsolete and no longer available for EABI.
  */
 #if !defined(__KERNEL__)


