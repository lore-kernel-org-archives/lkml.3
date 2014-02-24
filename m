Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaBXWAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:00:48 -0500
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:43899 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753062AbaBXWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:966:968:973:988:989:1042:1260:1345:1359:1437:1534:1544:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2894:3138:3139:3140:3141:3142:3355:3865:3867:4321:4385:4605:5007:6119:6261:7903:9040:10004:10026:10848:11026:11233:11473:11658:11914:12043:12296:12438:12517:12519:12555:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: love70_22f4f43c8c862
X-Filterd-Recvd-Size: 4977
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 6/8] security: smack: Use a more current logging style
Date: Mon, 24 Feb 2014 13:59:59 -0800
Message-Id: <3b69f0961dff21133e276d5c3edee8b05c41f8c5.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>
Add pr_fmt.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/smack/smack_lsm.c |  7 ++++---
 security/smack/smackfs.c   | 25 +++++++++++--------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 14f52be..a273aad 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -18,6 +18,8 @@
  *      as published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/xattr.h>
 #include <linux/pagemap.h>
 #include <linux/mount.h>
@@ -2106,8 +2108,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 		if (sock->sk->sk_family == PF_INET) {
 			rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
 			if (rc != 0)
-				printk(KERN_WARNING
-					"Smack: \"%s\" netlbl error %d.\n",
+				pr_warn("\"%s\" netlbl error %d\n",
 					__func__, -rc);
 		}
 	} else
@@ -3916,7 +3917,7 @@ static __init int smack_init(void)
 	if (tsp == NULL)
 		return -ENOMEM;
 
-	printk(KERN_INFO "Smack:  Initializing.\n");
+	pr_info("Initializing\n");
 
 	/*
 	 * Set the security state for the initial task.
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3198cfe..2e25220 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -16,6 +16,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/security.h>
@@ -698,8 +700,7 @@ static void smk_cipso_doi(void)
 
 	rc = netlbl_cfg_map_del(NULL, PF_INET, NULL, NULL, &nai);
 	if (rc != 0)
-		printk(KERN_WARNING "%s:%d remove rc = %d\n",
-		       __func__, __LINE__, rc);
+		pr_warn("%s:%d remove rc = %d\n", __func__, __LINE__, rc);
 
 	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
 	if (doip == NULL)
@@ -713,15 +714,13 @@ static void smk_cipso_doi(void)
 
 	rc = netlbl_cfg_cipsov4_add(doip, &nai);
 	if (rc != 0) {
-		printk(KERN_WARNING "%s:%d cipso add rc = %d\n",
-		       __func__, __LINE__, rc);
+		pr_warn("%s:%d cipso add rc = %d\n", __func__, __LINE__, rc);
 		kfree(doip);
 		return;
 	}
 	rc = netlbl_cfg_cipsov4_map_add(doip->doi, NULL, NULL, NULL, &nai);
 	if (rc != 0) {
-		printk(KERN_WARNING "%s:%d map add rc = %d\n",
-		       __func__, __LINE__, rc);
+		pr_warn("%s:%d map add rc = %d\n", __func__, __LINE__, rc);
 		kfree(doip);
 		return;
 	}
@@ -741,8 +740,8 @@ static void smk_unlbl_ambient(char *oldambient)
 	if (oldambient != NULL) {
 		rc = netlbl_cfg_map_del(oldambient, PF_INET, NULL, NULL, &nai);
 		if (rc != 0)
-			printk(KERN_WARNING "%s:%d remove rc = %d\n",
-			       __func__, __LINE__, rc);
+			pr_warn("%s:%d remove rc = %d\n",
+				__func__, __LINE__, rc);
 	}
 	if (smack_net_ambient == NULL)
 		smack_net_ambient = &smack_known_floor;
@@ -750,8 +749,7 @@ static void smk_unlbl_ambient(char *oldambient)
 	rc = netlbl_cfg_unlbl_map_add(smack_net_ambient->smk_known, PF_INET,
 				      NULL, NULL, &nai);
 	if (rc != 0)
-		printk(KERN_WARNING "%s:%d add rc = %d\n",
-		       __func__, __LINE__, rc);
+		pr_warn("%s:%d add rc = %d\n", __func__, __LINE__, rc);
 }
 
 /*
@@ -2302,8 +2300,7 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 
 	rc = simple_fill_super(sb, SMACK_MAGIC, smack_files);
 	if (rc != 0) {
-		printk(KERN_ERR "%s failed %d while creating inodes\n",
-			__func__, rc);
+		pr_err("%s failed %d while creating inodes\n", __func__, rc);
 		return rc;
 	}
 
@@ -2369,13 +2366,13 @@ static int __init init_smk_fs(void)
 
 	err = smk_init_sysfs();
 	if (err)
-		printk(KERN_ERR "smackfs: sysfs mountpoint problem.\n");
+		pr_err("smackfs: sysfs mountpoint problem\n");
 
 	err = register_filesystem(&smk_fs_type);
 	if (!err) {
 		smackfs_mount = kern_mount(&smk_fs_type);
 		if (IS_ERR(smackfs_mount)) {
-			printk(KERN_ERR "smackfs:  could not mount!\n");
+			pr_err("smackfs: could not mount!\n");
 			err = PTR_ERR(smackfs_mount);
 			smackfs_mount = NULL;
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

