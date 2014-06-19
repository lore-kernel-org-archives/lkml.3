Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbaFSN2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:28:23 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:40948 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaFSN2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:28:21 -0400
Message-ID: <53A2E573.6080407@acm.org>
Date: Thu, 19 Jun 2014 15:28:19 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] bug: Fix CONFIG_BUG=n BUG_ON()
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "bug: Make BUG() always stop the machine" changed the
behavior of BUG() with CONFIG_BUG=n from a no-op into an infinite
loop. Modify the definition of BUG_ON() accordingly such that the
behavior of BUG_ON(1) is identical to that of BUG().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/bug.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 630dd23..f3241cd 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -142,7 +142,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while (0)
+#define BUG_ON(condition) do { } while (unlikely(condition))
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
-- 
1.8.4.5

