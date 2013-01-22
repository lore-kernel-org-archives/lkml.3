Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3AVLYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:24:18 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45601 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3AVLYR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 22 Jan 2013 06:24:17 -0500
Message-Id: <50FE84EC02000078000B83B7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 22 Jan 2013 11:24:12 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <roland@hack.frob.com>, <linux-kernel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>
Subject: [PATCH] ix86: tighten asmlinkage_protect()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the description of the commit that originally introduced
asmlinkage_protect() validly says that this doesn't guarantee
clobbering of the function arguments, using "m" constraints rather
than "g" ones reduces the risk (by making it less attractive to the
compiler to move those variables into registers) and generally results
in better code (because we know the arguments are in memory anyway,
and are frequently - if not always - used just once, with the second
[compiler visible] use in asmlinkage_protect() itself being a fake
one).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/linkage.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- 3.8-rc4/arch/x86/include/asm/linkage.h
+++ 3.8-rc4-ix86-asmlinkage-protect/arch/x86/include/asm/linkage.h
@@ -27,20 +27,20 @@
 #define __asmlinkage_protect0(ret) \
 	__asmlinkage_protect_n(ret)
 #define __asmlinkage_protect1(ret, arg1) \
-	__asmlinkage_protect_n(ret, "g" (arg1))
+	__asmlinkage_protect_n(ret, "m" (arg1))
 #define __asmlinkage_protect2(ret, arg1, arg2) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2))
 #define __asmlinkage_protect3(ret, arg1, arg2, arg3) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3))
 #define __asmlinkage_protect4(ret, arg1, arg2, arg3, arg4) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
-			      "g" (arg4))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3), \
+			      "m" (arg4))
 #define __asmlinkage_protect5(ret, arg1, arg2, arg3, arg4, arg5) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
-			      "g" (arg4), "g" (arg5))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3), \
+			      "m" (arg4), "m" (arg5))
 #define __asmlinkage_protect6(ret, arg1, arg2, arg3, arg4, arg5, arg6) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
-			      "g" (arg4), "g" (arg5), "g" (arg6))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3), \
+			      "m" (arg4), "m" (arg5), "m" (arg6))
 
 #endif /* CONFIG_X86_32 */
 



