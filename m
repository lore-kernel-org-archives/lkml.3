Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaGNStz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:49:55 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41041 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaGNStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:49:47 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: cmetcalf@tilera.com
Cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        zlu@tilera.com, linux-kernel@vger.kernel.org
Subject: [PATCH] title: no lookup_page for if statement
Date: Mon, 14 Jul 2014 14:49:42 -0400
Message-Id: <1405363782-6570-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the if define statement for page_lookup in order
to remove a fix me of this not being defined as of yet.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 0001-title-no-lookup_page-for-if-statement.patch | 37 ++++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 0001-title-no-lookup_page-for-if-statement.patch

diff --git a/0001-title-no-lookup_page-for-if-statement.patch b/0001-title-no-lookup_page-for-if-statement.patch
new file mode 100644
index 0000000..f11c12e
--- /dev/null
+++ b/0001-title-no-lookup_page-for-if-statement.patch
@@ -0,0 +1,37 @@
+From 23c4afac6742d5df1d083ab6335a0a69f38c76b0 Mon Sep 17 00:00:00 2001
+From: Nicholas Krause <xerofoify@gmail.com>
+Date: Mon, 14 Jul 2014 14:39:02 -0400
+Subject: [PATCH] title: no lookup_page for if statement
+
+This patch removes the if define statement for page_lookup in order
+to remove a fix me of this not being defined as of yet.
+
+Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
+---
+ arch/tile/mm/fault.c | 3 ---
+ 1 file changed, 3 deletions(-)
+
+diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
+index 6c05712..2297bf7 100644
+--- a/arch/tile/mm/fault.c
++++ b/arch/tile/mm/fault.c
+@@ -513,8 +513,6 @@ no_context:
+ 
+ 	bust_spinlocks(1);
+ 
+-	/* FIXME: no lookup_address() yet */
+-#ifdef SUPPORT_LOOKUP_ADDRESS
+ 	if (fault_num == INT_ITLB_MISS) {
+ 		pte_t *pte = lookup_address(address);
+ 
+@@ -523,7 +521,6 @@ no_context:
+ 			       " non-executable page - exploit attempt?"
+ 			       " (uid: %d)\n", current->uid);
+ 	}
+-#endif
+ 	if (address < PAGE_SIZE)
+ 		pr_alert("Unable to handle kernel NULL pointer dereference\n");
+ 	else
+-- 
+1.9.1
+
-- 
1.9.1

