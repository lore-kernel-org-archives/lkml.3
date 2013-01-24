Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3AXUGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:06:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34287 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3AXUGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:06:46 -0500
Date: Thu, 24 Jan 2013 12:06:18 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-d59fe3f13d070489e63d04e1c9bfd819d5f71542@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, JBeulich@suse.com,
        tglx@linutronix.de, roland@hack.frob.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, JBeulich@suse.com,
        roland@hack.frob.com, tglx@linutronix.de
In-Reply-To: <50FE84EC02000078000B83B7@nat28.tlf.novell.com>
References: <50FE84EC02000078000B83B7@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] ix86: Tighten asmlinkage_protect() constraints
Git-Commit-ID: d59fe3f13d070489e63d04e1c9bfd819d5f71542
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:06:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d59fe3f13d070489e63d04e1c9bfd819d5f71542
Gitweb:     http://git.kernel.org/tip/d59fe3f13d070489e63d04e1c9bfd819d5f71542
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 22 Jan 2013 11:24:12 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 11:25:59 +0100

ix86: Tighten asmlinkage_protect() constraints

While the description of the commit that originally introduced
asmlinkage_protect() validly says that this doesn't guarantee
clobbering of the function arguments, using "m" constraints
rather than "g" ones reduces the risk (by making it less
attractive to the compiler to move those variables into
registers) and generally results in better code (because we know
the arguments are in memory anyway, and are frequently - if not
always - used just once, with the second [compiler visible] use
in asmlinkage_protect() itself being a fake one).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: <roland@hack.frob.com>
Cc: <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/50FE84EC02000078000B83B7@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/linkage.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 4814297..79327e9 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
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
 
