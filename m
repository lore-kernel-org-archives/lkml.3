Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3HVHWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:22:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3HVHWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:22:02 -0400
Date: Thu, 22 Aug 2013 00:21:46 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-eb86b5fd505cb97743d84226140cf247d91a2f03@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1377115662-4865-1-git-send-email-andi@firstfloor.org>
References: <1377115662-4865-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86/asmlinkage:
  Fix warning in xen asmlinkage change
Git-Commit-ID: eb86b5fd505cb97743d84226140cf247d91a2f03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 22 Aug 2013 00:21:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb86b5fd505cb97743d84226140cf247d91a2f03
Gitweb:     http://git.kernel.org/tip/eb86b5fd505cb97743d84226140cf247d91a2f03
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 21 Aug 2013 13:07:42 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 Aug 2013 09:17:19 +0200

x86/asmlinkage: Fix warning in xen asmlinkage change

Current code uses asmlinkage for functions without arguments.
This adds an implicit regparm(0) which creates a warning
when assigning the function to pointers.

Use __visible for the functions without arguments.
This avoids having to add regparm(0) to function pointers.
Since they have no arguments it does not make any difference.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1377115662-4865-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
