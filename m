Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaDGCr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 22:47:26 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45765 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaDGCrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 22:47:23 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: andreas.dilger@intel.com, bergwolf@gmail.com, alexey.zhuravlev@intel.com,
        mike.pershin@intel.com, xuezhao.liu@emc.com,
        nathaniel.l.clark@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: use NULL instead of 0 for pointer
Date: Mon, 07 Apr 2014 11:47:17 +0900
Message-ID: <4644961.L4Y074brEZ@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 6f8ba54..419a323 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -187,7 +187,7 @@ int lustre_start_simple(char *obdname, char *type, char *uuid,
 	int rc;
 	CDEBUG(D_MOUNT, "Starting obd %s (typ=%s)\n", obdname, type);
 
-	rc = do_lcfg(obdname, 0, LCFG_ATTACH, type, uuid, 0, 0);
+	rc = do_lcfg(obdname, 0, LCFG_ATTACH, type, uuid, NULL, NULL);
 	if (rc) {
 		CERROR("%s attach error %d\n", obdname, rc);
 		return rc;
@@ -195,7 +195,7 @@ int lustre_start_simple(char *obdname, char *type, char *uuid,
 	rc = do_lcfg(obdname, 0, LCFG_SETUP, s1, s2, s3, s4);
 	if (rc) {
 		CERROR("%s setup error %d\n", obdname, rc);
-		do_lcfg(obdname, 0, LCFG_DETACH, 0, 0, 0, 0);
+		do_lcfg(obdname, 0, LCFG_DETACH, NULL, NULL, NULL, NULL);
 	}
 	return rc;
 }
@@ -337,7 +337,8 @@ int lustre_start_mgc(struct super_block *sb)
 			lnet_process_id_t id;
 			while ((rc = LNetGetId(i++, &id)) != -ENOENT) {
 				rc = do_lcfg(mgcname, id.nid,
-					     LCFG_ADD_UUID, niduuid, 0,0,0);
+					     LCFG_ADD_UUID, niduuid,
+					     NULL, NULL, NULL);
 			}
 		} else {
 			/* Use mgsnode= nids */
@@ -351,7 +352,8 @@ int lustre_start_mgc(struct super_block *sb)
 			}
 			while (class_parse_nid(ptr, &nid, &ptr) == 0) {
 				rc = do_lcfg(mgcname, nid,
-					     LCFG_ADD_UUID, niduuid, 0,0,0);
+					     LCFG_ADD_UUID, niduuid,
+					     NULL, NULL, NULL);
 				i++;
 			}
 		}
@@ -360,7 +362,7 @@ int lustre_start_mgc(struct super_block *sb)
 		ptr = lsi->lsi_lmd->lmd_dev;
 		while (class_parse_nid(ptr, &nid, &ptr) == 0) {
 			rc = do_lcfg(mgcname, nid,
-				     LCFG_ADD_UUID, niduuid, 0,0,0);
+				     LCFG_ADD_UUID, niduuid, NULL, NULL, NULL);
 			i++;
 			/* Stop at the first failover nid */
 			if (*ptr == ':')
@@ -396,13 +398,13 @@ int lustre_start_mgc(struct super_block *sb)
 		while (class_parse_nid_quiet(ptr, &nid, &ptr) == 0) {
 			j++;
 			rc = do_lcfg(mgcname, nid,
-				     LCFG_ADD_UUID, niduuid, 0,0,0);
+				     LCFG_ADD_UUID, niduuid, NULL, NULL, NULL);
 			if (*ptr == ':')
 				break;
 		}
 		if (j > 0) {
 			rc = do_lcfg(mgcname, 0, LCFG_ADD_CONN,
-				     niduuid, 0, 0, 0);
+				     niduuid, NULL, NULL, NULL);
 			i++;
 		} else {
 			/* at ":/fsname" */
@@ -532,7 +534,7 @@ static int lustre_stop_mgc(struct super_block *sb)
 	for (i = 0; i < lsi->lsi_lmd->lmd_mgs_failnodes; i++) {
 		sprintf(ptr, "_%x", i);
 		rc = do_lcfg(LUSTRE_MGC_OBDNAME, 0, LCFG_DEL_UUID,
-			     niduuid, 0, 0, 0);
+			     niduuid, NULL, NULL, NULL);
 		if (rc)
 			CERROR("del MDC UUID %s failed: rc = %d\n",
 			       niduuid, rc);
-- 
1.7.4.4


