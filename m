Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaKIMYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 07:24:11 -0500
Received: from mail-pd0-f193.google.com ([209.85.192.193]:55964 "EHLO
	mail-pd0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaKIMYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 07:24:09 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: sjennings@variantweb.net, minchan@kernel.org
Cc: ddstreet@ieee.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zswap: add __init to some functions in zswap
Date: Sun,  9 Nov 2014 20:23:52 +0800
Message-Id: <1415535832-4822-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap_cpu_init/zswap_comp_exit/zswap_entry_cache_create is only
called by __init init_zswap()

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 51a2c45..2e621fa 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -149,7 +149,7 @@ static int __init zswap_comp_init(void)
 	return 0;
 }
 
-static void zswap_comp_exit(void)
+static void __init zswap_comp_exit(void)
 {
 	/* free percpu transforms */
 	if (zswap_comp_pcpu_tfms)
@@ -206,7 +206,7 @@ static struct zswap_tree *zswap_trees[MAX_SWAPFILES];
 **********************************/
 static struct kmem_cache *zswap_entry_cache;
 
-static int zswap_entry_cache_create(void)
+static int __init zswap_entry_cache_create(void)
 {
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
 	return zswap_entry_cache == NULL;
@@ -389,7 +389,7 @@ static struct notifier_block zswap_cpu_notifier_block = {
 	.notifier_call = zswap_cpu_notifier
 };
 
-static int zswap_cpu_init(void)
+static int __init zswap_cpu_init(void)
 {
 	unsigned long cpu;
 
-- 
1.7.9.5

