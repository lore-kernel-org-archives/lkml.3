Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3KYOF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:05:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59027 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447Ab3KYNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Santos" <daniel.santos@pobox.com>,
        "Andi Kleen" <ak@linux.intel.com>, "Borislav Petkov" <bp@alien8.de>,
        "Joe Perches" <joe@perches.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "David Rientjes" <rientjes@google.com>,
        "Josh Triplett" <josh@joshtriplett.org>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.663579247@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 59/87] compiler-gcc.h: Add gcc-recommended GCC_VERSION
 macro
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/compiler-gcc.h | 3 +++
 1 file changed, 3 insertions(+)

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

