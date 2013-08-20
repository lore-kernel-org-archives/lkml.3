Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab3HTAwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:52:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:20384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3HTAwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:52:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,915,1367996400"; 
   d="scan'208";a="388769418"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86, asmlinkage: Fix warning in xen asmlinkage change
Date: Mon, 19 Aug 2013 17:52:04 -0700
Message-Id: <1376959924-13790-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use __visible for some functions without arguments.
This avoids having to add regparm(0) to function pointers.
Since they have no arguments it does not make any difference.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/xen/xen-ops.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index d380213..95f8c61 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -105,7 +105,7 @@ static inline void __init xen_init_apic(void)
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
-	asmlinkage ret name(__VA_ARGS__);	\
+	__visible ret name(__VA_ARGS__);	\
 	extern char name##_end[] __visible;	\
 	extern char name##_reloc[] __visible
 
@@ -115,11 +115,11 @@ DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
 /* These are not functions, and cannot be called normally */
-asmlinkage void xen_iret(void);
-asmlinkage void xen_sysexit(void);
-asmlinkage void xen_sysret32(void);
-asmlinkage void xen_sysret64(void);
-asmlinkage void xen_adjust_exception_frame(void);
+__visible void xen_iret(void);
+__visible void xen_sysexit(void);
+__visible void xen_sysret32(void);
+__visible void xen_sysret64(void);
+__visible void xen_adjust_exception_frame(void);
 
 extern int xen_panic_handler_init(void);
 
-- 
1.8.3.1

