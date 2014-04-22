Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaDVD7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:59:42 -0400
Received: from ozlabs.org ([103.22.144.67]:60370 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbaDVD7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Alexey Dobriyan <adobriyan@gmail.com>, Dave Jones <davej@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 9/9] sysfs: disallow world-writable files.
Date: Tue, 22 Apr 2014 13:03:32 +0930
Message-Id: <1398137612-9714-10-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This check was introduced in 2006 by Alexey Dobriyan (9774a1f54f173)
for module parameters; we removed it when we unified the check into
VERIFY_OCTAL_PERMISSIONS() as sysfs didn't have the same requirement.
Now all those users are fixed, reintroduce it.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/kernel.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907a6d8b..43e1c6a9683e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -849,5 +849,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 	 /* User perms >= group perms >= other perms */			\
 	 BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
 	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)) +	\
+	 /* Other writable?  Generally considered a bad idea. */	\
+	 BUILD_BUG_ON_ZERO((perms) & 2) +				\
 	 (perms))
 #endif
-- 
1.8.3.2

