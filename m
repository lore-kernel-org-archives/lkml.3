Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaIKNTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:19:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51498 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Fengguang Wu" <fengguang.wu@intel.com>
Date: Thu, 11 Sep 2014 13:32:14 +0100
Message-ID: <lsq.1410438734.665181735@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 125/131] x86, espfix: Move espfix definitions into a
 separate  header file
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit e1fe9ed8d2a4937510d0d60e20705035c2609aea upstream.

Sparse warns that the percpu variables aren't declared before they are
defined.  Rather than hacking around it, move espfix definitions into
a proper header file.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/espfix.h | 16 ++++++++++++++++
 arch/x86/include/asm/setup.h  |  5 ++---
 arch/x86/kernel/espfix_64.c   |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/espfix.h

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
@@ -59,11 +59,10 @@ extern void x86_ce4100_early_setup(void);
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

