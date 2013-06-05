Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab3FEVsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:48:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab3FEVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 087/127] powerpc/tm: Move TM abort cause codes to uapi
Date: Wed,  5 Jun 2013 14:34:14 -0700
Message-Id: <20130605213227.781591861@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit b75c100ef24894bd2c8b52e123bcc5f191c5d9fd upstream.

These cause codes are usable by userspace, so let's export to uapi.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/reg.h       |   14 --------------
 arch/powerpc/include/asm/tm.h        |    2 ++
 arch/powerpc/include/uapi/asm/Kbuild |    1 +
 arch/powerpc/include/uapi/asm/tm.h   |   18 ++++++++++++++++++
 4 files changed, 21 insertions(+), 14 deletions(-)

--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -111,20 +111,6 @@
 #define MSR_TM_TRANSACTIONAL(x)	(((x) & MSR_TS_MASK) == MSR_TS_T)
 #define MSR_TM_SUSPENDED(x)	(((x) & MSR_TS_MASK) == MSR_TS_S)
 
-/* Reason codes describing kernel causes for transaction aborts.  By
-   convention, bit0 is copied to TEXASR[56] (IBM bit 7) which is set if
-   the failure is persistent.  PAPR saves 0xff-0xe0 for the hypervisor.
-*/
-#define TM_CAUSE_PERSISTENT	0x01
-#define TM_CAUSE_RESCHED	0xde
-#define TM_CAUSE_TLBI		0xdc
-#define TM_CAUSE_FAC_UNAV	0xda
-#define TM_CAUSE_SYSCALL	0xd8  /* future use */
-#define TM_CAUSE_MISC		0xd6  /* future use */
-#define TM_CAUSE_SIGNAL		0xd4
-#define TM_CAUSE_ALIGNMENT	0xd2
-#define TM_CAUSE_EMULATE	0xd0
-
 #if defined(CONFIG_PPC_BOOK3S_64)
 #define MSR_64BIT	MSR_SF
 
--- a/arch/powerpc/include/asm/tm.h
+++ b/arch/powerpc/include/asm/tm.h
@@ -5,6 +5,8 @@
  * Copyright 2012 Matt Evans & Michael Neuling, IBM Corporation.
  */
 
+#include <uapi/asm/tm.h>
+
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 extern void do_load_up_transact_fpu(struct thread_struct *thread);
 extern void do_load_up_transact_altivec(struct thread_struct *thread);
--- a/arch/powerpc/include/uapi/asm/Kbuild
+++ b/arch/powerpc/include/uapi/asm/Kbuild
@@ -40,6 +40,7 @@ header-y += statfs.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
+header-y += tm.h
 header-y += types.h
 header-y += ucontext.h
 header-y += unistd.h
--- /dev/null
+++ b/arch/powerpc/include/uapi/asm/tm.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_POWERPC_TM_H
+#define _ASM_POWERPC_TM_H
+
+/* Reason codes describing kernel causes for transaction aborts.  By
+ * convention, bit0 is copied to TEXASR[56] (IBM bit 7) which is set if
+ * the failure is persistent.  PAPR saves 0xff-0xe0 for the hypervisor.
+ */
+#define TM_CAUSE_PERSISTENT	0x01
+#define TM_CAUSE_RESCHED	0xde
+#define TM_CAUSE_TLBI		0xdc
+#define TM_CAUSE_FAC_UNAV	0xda
+#define TM_CAUSE_SYSCALL	0xd8  /* future use */
+#define TM_CAUSE_MISC		0xd6  /* future use */
+#define TM_CAUSE_SIGNAL		0xd4
+#define TM_CAUSE_ALIGNMENT	0xd2
+#define TM_CAUSE_EMULATE	0xd0
+
+#endif


