Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3J2SFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:05:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3J2SFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Santos <daniel.santos@pobox.com>, Andi Kleen <ak@linux.intel.com>,
        Joe Perches <joe@perches.com>, Josh Triplett <josh@joshtriplett.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 17/81] compiler-gcc4.h: Reorder macros based upon gcc ver
Date: Tue, 29 Oct 2013 11:03:38 -0700
Message-Id: <1383069882-11437-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Santos <daniel.santos@pobox.com>

commit 6640dfdf6fff387c0a8f7fb8ac1d47c6b093484e upstream.

This helps to keep the file from getting confusing, removes one
duplicate version check and should encourage future editors to put new
macros where they belong.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8-stable prereq for
  3f0116c "compiler/gcc4: Add quirk for 'asm goto' miscompilation bug" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/compiler-gcc4.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 662fd1b..c9785c2 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -13,6 +13,10 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
+#if __GNUC_MINOR__ > 0
+# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
+
 #if __GNUC_MINOR__ >= 3
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
@@ -33,6 +37,12 @@
 
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+#endif /* __GNUC_MINOR__ >= 3 */
+
 #if __GNUC_MINOR__ >= 5
 /*
  * Mark a position in code as unreachable.  This can be used to
@@ -48,8 +58,7 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif
-#endif
+#endif /* __GNUC_MINOR__ >= 5 */
 
 #if __GNUC_MINOR__ >= 6
 /*
@@ -58,13 +67,6 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
-#if __GNUC_MINOR__ > 0
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
-#define __compiletime_warning(message) __attribute__((warning(message)))
-#define __compiletime_error(message) __attribute__((error(message)))
-#endif
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if __GNUC_MINOR__ >= 4
-- 
1.8.1.2

