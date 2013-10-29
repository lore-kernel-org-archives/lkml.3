Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab3J2SF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:05:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3J2SFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Santos <daniel.santos@pobox.com>, Andi Kleen <ak@linux.intel.com>,
        Joe Perches <joe@perches.com>, Josh Triplett <josh@joshtriplett.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 18/81] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Tue, 29 Oct 2013 11:03:39 -0700
Message-Id: <1383069882-11437-19-git-send-email-kamal@canonical.com>
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

commit 3f3f8d2f48acfd8ed3b8e6b7377935da57b27b16 upstream.

Throughout compiler*.h, many version checks are made.  These can be
simplified by using the macro that gcc's documentation recommends.
However, my primary reason for adding this is that I need bug-check
macros that are enabled at certain gcc versions and it's cleaner to use
this macro than the tradition method:

  #if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ => 2)

If you add patch level, it gets this ugly:

  #if __GNUC__ > 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ > 2 || \
      __GNUC_MINOR__ == 2 __GNUC_PATCHLEVEL__ >= 1))

As opposed to:

  #if GCC_VERSION >= 40201

While having separate headers for gcc 3 & 4 eliminates some of this
verbosity, they can still be cleaned up by this.

See also:

  http://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Acked-by: David Rientjes <rientjes@google.com>
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
 include/linux/compiler-gcc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 6a6d7ae..24545cd 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -5,6 +5,9 @@
 /*
  * Common definitions for all gcc versions go here.
  */
+#define GCC_VERSION (__GNUC__ * 10000 \
+		   + __GNUC_MINOR__ * 100 \
+		   + __GNUC_PATCHLEVEL__)
 
 
 /* Optimization barrier */
-- 
1.8.1.2

