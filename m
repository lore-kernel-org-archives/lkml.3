Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaESTZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:25:19 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:28281 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbaESTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:25:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMVAExaelNbtAXp/2dsb2JhbABZgwaqdwQBAQEBAQEFAZonAgKBGRd0glMTHCMYgQIkE4hFAdJahVWIe4RHAQOPL4oqAYsRiAmDOTs
Date: Mon, 19 May 2014 21:25:13 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 1/1] mm/kmemleak-test.c: use pr_fmt for logging
Message-Id: <20140519212513.d1a073065c000cde2394f8cd@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/kmemleak-test.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/kmemleak-test.c b/mm/kmemleak-test.c
index ff0d977..dcdcadb 100644
--- a/mm/kmemleak-test.c
+++ b/mm/kmemleak-test.c
@@ -18,6 +18,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#define pr_fmt(fmt) "kmemleak: " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -50,25 +52,25 @@ static int __init kmemleak_test_init(void)
 	printk(KERN_INFO "Kmemleak testing\n");
 
 	/* make some orphan objects */
-	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
-	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
 #ifndef CONFIG_MODULES
-	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
-	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+	pr_info("kmem_cache_alloc(files_cachep) = %p\n",
 		kmem_cache_alloc(files_cachep, GFP_KERNEL));
 #endif
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
-	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("vmalloc(64) = %p\n", vmalloc(64));
 
 	/*
 	 * Add elements to a list. They should only appear as orphan
@@ -76,7 +78,7 @@ static int __init kmemleak_test_init(void)
 	 */
 	for (i = 0; i < 10; i++) {
 		elem = kzalloc(sizeof(*elem), GFP_KERNEL);
-		pr_info("kmemleak: kzalloc(sizeof(*elem)) = %p\n", elem);
+		pr_info("kzalloc(sizeof(*elem)) = %p\n", elem);
 		if (!elem)
 			return -ENOMEM;
 		INIT_LIST_HEAD(&elem->list);
@@ -85,7 +87,7 @@ static int __init kmemleak_test_init(void)
 
 	for_each_possible_cpu(i) {
 		per_cpu(kmemleak_test_pointer, i) = kmalloc(129, GFP_KERNEL);
-		pr_info("kmemleak: kmalloc(129) = %p\n",
+		pr_info("kmalloc(129) = %p\n",
 			per_cpu(kmemleak_test_pointer, i));
 	}
 
-- 
1.8.4.5
