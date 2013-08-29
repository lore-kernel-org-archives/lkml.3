Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3H2TPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:15:12 -0400
Received: from mout.gmx.net ([212.227.15.15]:53373 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab3H2TPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:15:08 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: pageexec@freemail.hu, llvmlinux@lists.linuxfoundation.org,
        behanw@converseincode.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Extend definitions of _ASM_* with a raw format.
Date: Thu, 29 Aug 2013 21:13:04 +0200
Message-Id: <1377803585-5913-2-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377803585-5913-1-git-send-email-dl9pf@gmx.de>
References: <1563930.LeGpPqNO9R@aragorn.auenland.lan>
 <1377803585-5913-1-git-send-email-dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:9mV+UbpAry7jenc5Zlv7p7Mv9ywo6CY3dk/plrRKN7m0fTKrc23
 B9sbyWVhWyLgcV+mjbokbZ6oYgevhBTnpEWFSZhmP/WhXz3MXh5vvE4bhyJkl55SmOJyZeE
 vvouFJJdEHqeZ6vOH3GzEKBZvd4GIcRYLE4EYvANJEna13TnvahHzCOYiqfWJBXx+SdQGE0
 /KFYehXyzj4iYZRn759jw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

The __ASM_* macros (e.g. __ASM_DX) are used to return the proper
register name (e.g. edx for 32bit / rdx for 64bit). We want to use this
also in arch/x86/include/asm/uaccess.h / get_user() .
For this to work, we need a raw form as both gcc and clang choke on the
whitespace introduced by __ASM_FORM. Thus __ASM_FORM_RAW was added.
We change __ASM_REG to use the new RAW form.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
CC: pageexec@freemail.hu
CC: llvmlinux@lists.linuxfoundation.org
CC: behanw@converseincode.com
CC: hpa@zytor.com
CC: linux-kernel@vger.kernel.org
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
-- 
1.8.1.4

