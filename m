Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752AbaDJDWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628AbaDJDVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Santos <daniel.santos@pobox.com>,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Andi Kleen <ak@linux.intel.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 006/134] compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Date: Wed,  9 Apr 2014 20:22:02 -0700
Message-Id: <20140410032300.502710445@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-gcc.h |    3 +++
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


