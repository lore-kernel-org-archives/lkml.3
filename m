Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3H2UbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:31:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3H2UbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:31:23 -0400
Date: Thu, 29 Aug 2013 13:30:56 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgSmFuLVNpbW9uIE3DtmxsZXI=?=" 
	<tipbot@zytor.com>
Message-ID: <tip-3e9b2327b59801e677a7581fe4d2541ca749dcab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dl9pf@gmx.de, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dl9pf@gmx.de, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1377803585-5913-2-git-send-email-dl9pf@gmx.de>
References: <1377803585-5913-2-git-send-email-dl9pf@gmx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm:
  Extend definitions of _ASM_* with a raw format
Git-Commit-ID: 3e9b2327b59801e677a7581fe4d2541ca749dcab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 13:31:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e9b2327b59801e677a7581fe4d2541ca749dcab
Gitweb:     http://git.kernel.org/tip/3e9b2327b59801e677a7581fe4d2541ca749dcab
Author:     Jan-Simon Möller <dl9pf@gmx.de>
AuthorDate: Thu, 29 Aug 2013 21:13:04 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Aug 2013 13:26:32 -0700

x86, asm: Extend definitions of _ASM_* with a raw format

The __ASM_* macros (e.g. __ASM_DX) are used to return the proper
register name (e.g. edx for 32bit / rdx for 64bit). We want to use
this also in arch/x86/include/asm/uaccess.h / get_user() .  For this
to work, we need a raw form as both gcc and clang choke on the
whitespace in a register asm() statement, and the __ASM_FORM macro
surrounds the argument with blanks.  A new macro, __ASM_FORM_RAW was
added and we change __ASM_REG to use the new RAW form.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Link: http://lkml.kernel.org/r/1377803585-5913-2-git-send-email-dl9pf@gmx.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/asm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 1c2d247..4582e8e 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -3,21 +3,25 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
+# define __ASM_FORM_RAW(x)     x
 # define __ASM_FORM_COMMA(x) x,
 #else
 # define __ASM_FORM(x)	" " #x " "
+# define __ASM_FORM_RAW(x)     #x
 # define __ASM_FORM_COMMA(x) " " #x ","
 #endif
 
 #ifdef CONFIG_X86_32
 # define __ASM_SEL(a,b) __ASM_FORM(a)
+# define __ASM_SEL_RAW(a,b) __ASM_FORM_RAW(a)
 #else
 # define __ASM_SEL(a,b) __ASM_FORM(b)
+# define __ASM_SEL_RAW(a,b) __ASM_FORM_RAW(b)
 #endif
 
 #define __ASM_SIZE(inst, ...)	__ASM_SEL(inst##l##__VA_ARGS__, \
 					  inst##q##__VA_ARGS__)
-#define __ASM_REG(reg)		__ASM_SEL(e##reg, r##reg)
+#define __ASM_REG(reg)         __ASM_SEL_RAW(e##reg, r##reg)
 
 #define _ASM_PTR	__ASM_SEL(.long, .quad)
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
