Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab3GZVO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:14:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57493 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028Ab3GZVOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:14:23 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 4/5] rbtree: allow tests to run as builtin
Date: Fri, 26 Jul 2013 14:13:42 -0700
Message-Id: <1374873223-25557-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072621-7182-0000-0000-000007E11384
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason require rbtree test code to be a module, allow it to be
builtin (streamlines my development process)

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1501aa5..606e3c8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1442,7 +1442,7 @@ config BACKTRACE_SELF_TEST
 
 config RBTREE_TEST
 	tristate "Red-Black tree test"
-	depends on m && DEBUG_KERNEL
+	depends on DEBUG_KERNEL
 	help
 	  A benchmark measuring the performance of the rbtree library.
 	  Also includes rbtree invariant checks.
-- 
1.8.3.4

