Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbbAXNs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 08:48:56 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39182 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbAXNsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 08:48:54 -0500
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zsmalloc: add log for module load/unload
Date: Sat, 24 Jan 2015 21:48:41 +0800
Message-Id: <1422107321-9973-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, we want to know whether a module is loaded or unloaded
from the log.

This patch adds some log.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2d5f5be..16617e9 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -72,6 +72,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #ifdef CONFIG_ZSMALLOC_DEBUG
 #define DEBUG
 #endif
@@ -1460,6 +1462,8 @@ static int __init zs_init(void)
 {
 	int ret = zs_register_cpu_notifier();
 
+	pr_info("loaded\n");
+
 	if (ret)
 		goto notifier_fail;
 
@@ -1474,6 +1478,7 @@ static int __init zs_init(void)
 		pr_err("zs stat initialization failed\n");
 		goto stat_fail;
 	}
+
 	return 0;
 
 stat_fail:
@@ -1483,6 +1488,8 @@ stat_fail:
 notifier_fail:
 	zs_unregister_cpu_notifier();
 
+	pr_info("unloaded\n");
+
 	return ret;
 }
 
-- 
1.7.9.5

