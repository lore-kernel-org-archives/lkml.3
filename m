Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3BPIhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:37:52 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:52351 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3BPIhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:37:17 -0500
From: Robert Berger <git.rber@gmail.com>
To: devel@driverdev.osuosl.org, konrad.wilk@oracle.com
Cc: gregkh@linuxfoundation.org, sjenning@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, minchan@kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, git.rber@gmail.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Subject: [PATCH 3/4] staging/zache KBUILD_MODNAME and checkpatch fixes
Date: Sat, 16 Feb 2013 10:35:53 +0200
Message-Id: <1361003754-22512-4-git-send-email-rber.git@ReliableEmbeddedSystems.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
References: <git.rber@gmail.com>
 <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KBUILD_MODNAME instead of "ramster: "

checkpatch fixes:
ramster.c:474: WARNING: line over 80 characters
ramster.c:749: WARNING: quoted string split across lines
ramster.c:756: WARNING: quoted string split across lines

Signed-off-by: Robert Berger <rber.git@ReliableEmbeddedSystems.com>
---
 drivers/staging/zcache/ramster/ramster.c |   34 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/zcache/ramster/ramster.c b/drivers/staging/zcache/ramster/ramster.c
index c06709f..3db1bee 100644
--- a/drivers/staging/zcache/ramster/ramster.c
+++ b/drivers/staging/zcache/ramster/ramster.c
@@ -26,6 +26,8 @@
  * be added over time.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/highmem.h>
@@ -471,7 +473,8 @@ void ramster_count_foreign_pages(bool eph, int count)
 			if (c > ramster_foreign_eph_pages_max)
 				ramster_foreign_eph_pages_max = c;
 		} else {
-			c = atomic_dec_return(&ramster_foreign_eph_pages_atomic);
+			c = atomic_dec_return(
+				&ramster_foreign_eph_pages_atomic);
 			WARN_ON_ONCE(c < 0);
 		}
 		ramster_foreign_eph_pages = c;
@@ -702,16 +705,15 @@ static ssize_t ramster_manual_node_up_store(struct kobject *kobj,
 
 	err = kstrtoul(buf, 10, &node_num);
 	if (err) {
-		pr_err("ramster: bad strtoul?\n");
+		pr_err("bad strtoul?\n");
 		return -EINVAL;
 	}
 	if (node_num >= MANUAL_NODES) {
-		pr_err("ramster: bad node_num=%lu?\n", node_num);
+		pr_err("bad node_num=%lu?\n", node_num);
 		return -EINVAL;
 	}
 	if (ramster_nodes_manual_up[node_num]) {
-		pr_err("ramster: node %d already up, ignoring\n",
-							(int)node_num);
+		pr_err("node %d already up, ignoring\n", (int)node_num);
 	} else {
 		ramster_nodes_manual_up[node_num] = true;
 		r2net_hb_node_up_manual((int)node_num);
@@ -742,25 +744,23 @@ static ssize_t ramster_remote_target_nodenum_store(struct kobject *kobj,
 
 	err = kstrtoul(buf, 10, &node_num);
 	if (err) {
-		pr_err("ramster: bad strtoul?\n");
+		pr_err("bad strtoul?\n");
 		return -EINVAL;
 	} else if (node_num == -1UL) {
-		pr_err("ramster: disabling all remotification, "
-			"data may still reside on remote nodes however\n");
+		pr_err("disabling all remotification, data may still reside on remote nodes however\n");
 		return -EINVAL;
 	} else if (node_num >= MANUAL_NODES) {
-		pr_err("ramster: bad node_num=%lu?\n", node_num);
+		pr_err("bad node_num=%lu?\n", node_num);
 		return -EINVAL;
 	} else if (!ramster_nodes_manual_up[node_num]) {
-		pr_err("ramster: node %d not up, ignoring setting "
-			"of remotification target\n", (int)node_num);
+		pr_err("node %d not up, ignoring setting of remotification target\n",
+			(int)node_num);
 	} else if (r2net_remote_target_node_set((int)node_num) >= 0) {
-		pr_info("ramster: node %d set as remotification target\n",
-				(int)node_num);
+		pr_info("node %d set as remotification target\n",
+		(int)node_num);
 		ramster_remote_target_nodenum = (int)node_num;
 	} else {
-		pr_err("ramster: bad num to node node_num=%d?\n",
-				(int)node_num);
+		pr_err("bad num to node node_num=%d?\n", (int)node_num);
 		return -EINVAL;
 	}
 	return count;
@@ -970,14 +970,14 @@ void __init ramster_init(bool cleancache, bool frontswap,
 	ramster_debugfs_init();
 	ret = sysfs_create_group(mm_kobj, &ramster_attr_group);
 	if (ret)
-		pr_err("ramster: can't create sysfs for ramster\n");
+		pr_err("can't create sysfs for ramster\n");
 	(void)r2net_register_handlers();
 	INIT_LIST_HEAD(&ramster_rem_op_list);
 	ramster_flnode_cache = kmem_cache_create("ramster_flnode",
 				sizeof(struct flushlist_node), 0, 0, NULL);
 	frontswap_selfshrinking = use_frontswap_selfshrink;
 	if (frontswap_selfshrinking) {
-		pr_info("ramster: Initializing frontswap selfshrink driver.\n");
+		pr_info("Initializing frontswap selfshrink driver.\n");
 		schedule_delayed_work(&selfshrink_worker,
 					selfshrink_interval * HZ);
 	}
-- 
1.7.9.5

