Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757Ab3BOKyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:54:24 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50389 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab3BOKyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:54:23 -0500
From: Robert Berger <git.rber@gmail.com>
To: devel@driverdev.osuosl.org, konrad.wilk@oracle.com
Cc: gregkh@linuxfoundation.org, sjenning@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, minchan@kernel.org,
        linux-kernel@vger.kernel.org, rber.git@gmail.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Subject: [PATCH] staging/zcache fixed some checkpatch issues
Date: Fri, 15 Feb 2013 12:53:00 +0200
Message-Id: <1360925580-18633-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <staging/zcache fixed some checkpatch issues>
References: <staging/zcache fixed some checkpatch issues>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmem.c:76: ERROR: "foo*bar" should be "foo *bar"
zcache-main.c:2057: WARNING: quoted string split across lines
zcache-main.c:2059: WARNING: Prefer pr_warn(... to pr_warning(...
zcache-main.c:2068: WARNING: quoted string split across lines
zcache-main.c:2070: WARNING: Prefer pr_warn(... to pr_warning(...

Signed-off-by: Robert Berger <rber.git@ReliableEmbeddedSystems.com>
---
 drivers/staging/zcache/tmem.c        |    2 +-
 drivers/staging/zcache/zcache-main.c |   10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/zcache/tmem.c b/drivers/staging/zcache/tmem.c
index 56c8e60..7d3f3d9 100644
--- a/drivers/staging/zcache/tmem.c
+++ b/drivers/staging/zcache/tmem.c
@@ -73,7 +73,7 @@ void tmem_register_pamops(struct tmem_pamops *m)
  */
 
 static struct tmem_obj
-*__tmem_obj_find(struct tmem_hashbucket*hb, struct tmem_oid *oidp,
+*__tmem_obj_find(struct tmem_hashbucket *hb, struct tmem_oid *oidp,
 		 struct rb_node **parent, struct rb_node ***link)
 {
 	struct rb_node *_parent = NULL, **rbnode;
diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 52b43b7..0803ea3 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -2053,10 +2053,9 @@ static int __init zcache_init(void)
 		zbud_init();
 		register_shrinker(&zcache_shrinker);
 		old_ops = zcache_cleancache_register_ops();
-		pr_info("zcache: cleancache enabled using kernel "
-			"transcendent memory and compression buddies\n");
+		pr_info("zcache: cleancache enabled using kernel transcendent memory and compression buddies\n");
 		if (old_ops.init_fs != NULL)
-			pr_warning("zcache: cleancache_ops overridden");
+			pr_warn("zcache: cleancache_ops overridden");
 	}
 #endif
 #ifdef CONFIG_FRONTSWAP
@@ -2064,10 +2063,9 @@ static int __init zcache_init(void)
 		struct frontswap_ops old_ops;
 
 		old_ops = zcache_frontswap_register_ops();
-		pr_info("zcache: frontswap enabled using kernel "
-			"transcendent memory and zsmalloc\n");
+		pr_info("zcache: frontswap enabled using kernel transcendent memory and zsmalloc\n");
 		if (old_ops.init != NULL)
-			pr_warning("zcache: frontswap_ops overridden");
+			pr_warn("zcache: frontswap_ops overridden");
 	}
 #endif
 out:
-- 
1.7.9.5

