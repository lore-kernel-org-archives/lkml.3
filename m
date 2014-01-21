Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaAUVYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:24:09 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50566 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaAUVYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 01/73] init: delete the __cpuinit related stubs
Date: Tue, 21 Jan 2014 16:22:04 -0500
Message-ID: <1390339396-3479-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit support was removed several releases ago.  People
have had a chance to update their out of tree code, so now we
remove the no-op stubs.

Also delete the mention of __cpuinitdata from the tag script.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/init.h | 11 -----------
 scripts/tags.sh      |  2 +-
 2 files changed, 1 insertion(+), 12 deletions(-)
 mode change 100755 => 100644 scripts/tags.sh

diff --git a/include/linux/init.h b/include/linux/init.h
index e168880..f693cc3 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -91,14 +91,6 @@
 
 #define __exit          __section(.exit.text) __exitused __cold notrace
 
-/* temporary, until all users are removed */
-#define __cpuinit
-#define __cpuinitdata
-#define __cpuinitconst
-#define __cpuexit
-#define __cpuexitdata
-#define __cpuexitconst
-
 /* Used for MEMORY_HOTPLUG */
 #define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
@@ -116,9 +108,6 @@
 #define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
-/* temporary, until all users are removed */
-#define __CPUINIT
-
 #define __MEMINIT        .section	".meminit.text", "ax"
 #define __MEMINITDATA    .section	".meminit.data", "aw"
 #define __MEMINITRODATA  .section	".meminit.rodata", "a"
diff --git a/scripts/tags.sh b/scripts/tags.sh
old mode 100755
new mode 100644
index 58c4559..78382c2
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -150,7 +150,7 @@ exuberant()
 {
 	all_target_sources | xargs $1 -a                        \
 	-I __initdata,__exitdata,__initconst,			\
-	-I __cpuinitdata,__initdata_memblock			\
+	-I __initdata_memblock					\
 	-I __refdata,__attribute,__maybe_unused,__always_unused \
 	-I __acquires,__releases,__deprecated			\
 	-I __read_mostly,__aligned,____cacheline_aligned        \
-- 
1.8.4.1

