Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaHESXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:23:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaHESOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.10 13/27] x86, espfix: Move espfix definitions into a separate header file
Date: Tue,  5 Aug 2014 11:14:05 -0700
Message-Id: <20140805181344.659552365@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181344.268039690@linuxfoundation.org>
References: <20140805181344.268039690@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit e1fe9ed8d2a4937510d0d60e20705035c2609aea upstream.

Sparse warns that the percpu variables aren't declared before they are
defined.  Rather than hacking around it, move espfix definitions into
a proper header file.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/espfix.h |   16 ++++++++++++++++
 arch/x86/include/asm/setup.h  |    5 ++---
 arch/x86/kernel/espfix_64.c   |    1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

--- /dev/null
+++ b/arch/x86/include/asm/espfix.h
@@ -0,0 +1,16 @@
+#ifdef _ASM_X86_ESPFIX_H
+#define _ASM_X86_ESPFIX_H
+
+#ifdef CONFIG_X86_64
+
+#include <asm/percpu.h>
+
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_waddr);
+
+extern void init_espfix_bsp(void);
+extern void init_espfix_ap(void);
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_ESPFIX_H */
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -60,11 +60,10 @@ extern void x86_ce4100_early_setup(void)
 static inline void x86_ce4100_early_setup(void) { }
 #endif
 
-extern void init_espfix_bsp(void);
-extern void init_espfix_ap(void);
-
 #ifndef _SETUP
 
+#include <asm/espfix.h>
+
 /*
  * This is set up by the setup-routine at boot-time
  */
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -40,6 +40,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/setup.h>
+#include <asm/espfix.h>
 
 /*
  * Note: we only need 6*8 = 48 bytes for the espfix stack, but round


