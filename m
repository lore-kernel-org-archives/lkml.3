Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3GTSiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 14:38:17 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56228 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3GTSiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 14:38:16 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Cc: bergwolf@gmail.com, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: lustre: Fix typo in printk
Date: Sun, 21 Jul 2013 03:38:08 +0900
Message-Id: <1374345488-27894-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.3.3.820.ge3d4493
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in printk within staging/lustre

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/lustre/lustre/llite/vvp_io.c             | 2 +-
 drivers/staging/lustre/lustre/obdclass/genops.c          | 2 +-
 drivers/staging/lustre/lustre/obdecho/echo_client.c      | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index eb964ac..8001f2d 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -968,7 +968,7 @@ static int vvp_io_commit_write(const struct lu_env *env,
 	LINVRNT(cl_page_is_vmlocked(env, pg));
 	LASSERT(vmpage->mapping->host == inode);
 
-	LU_OBJECT_HEADER(D_INODE, env, &obj->co_lu, "commiting page write\n");
+	LU_OBJECT_HEADER(D_INODE, env, &obj->co_lu, "committing page write\n");
 	CL_PAGE_HEADER(D_PAGE, env, pg, "committing: [%d, %d]\n", from, to);
 
 	/*
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index d96876e..ea041a3 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -1484,7 +1484,7 @@ int obd_export_evict_by_uuid(struct obd_device *obd, const char *uuid)
 		CERROR("%s: can't disconnect %s: no exports found\n",
 		       obd->obd_name, uuid);
 	} else {
-		CWARN("%s: evicting %s at adminstrative request\n",
+		CWARN("%s: evicting %s at administrative request\n",
 		       obd->obd_name, doomed_exp->exp_client_uuid.uuid);
 		class_fail_export(doomed_exp);
 		class_export_put(doomed_exp);
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 184195f..391878d 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -648,7 +648,7 @@ static int echo_site_init(const struct lu_env *env, struct echo_device *ed)
 	/* initialize site */
 	rc = cl_site_init(site, &ed->ed_cl);
 	if (rc) {
-		CERROR("Cannot initilize site for echo client(%d)\n", rc);
+		CERROR("Cannot initialize site for echo client(%d)\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
index 4b28931..91da763 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
@@ -341,7 +341,7 @@ __u32 import_context_rfc1964(struct krb5_ctx *kctx, char *p, char *end)
 	if (p != end)
 		goto out_err;
 
-	CDEBUG(D_SEC, "succesfully imported rfc1964 context\n");
+	CDEBUG(D_SEC, "successfully imported rfc1964 context\n");
 	return 0;
 out_err:
 	return GSS_S_FAILURE;
@@ -403,7 +403,7 @@ __u32 import_context_rfc4121(struct krb5_ctx *kctx, char *p, char *end)
 	if (get_keyblock(&p, end, &kctx->kc_keyc, keysize))
 		goto out_err;
 
-	CDEBUG(D_SEC, "succesfully imported v2 context\n");
+	CDEBUG(D_SEC, "successfully imported v2 context\n");
 	return 0;
 out_err:
 	return GSS_S_FAILURE;
@@ -494,7 +494,7 @@ __u32 gss_copy_reverse_context_kerberos(struct gss_ctx *gctx,
 		goto out_err;
 
 	gctx_new->internal_ctx_id = knew;
-	CDEBUG(D_SEC, "succesfully copied reverse context\n");
+	CDEBUG(D_SEC, "successfully copied reverse context\n");
 	return GSS_S_COMPLETE;
 
 out_err:
-- 
1.8.3.3.820.ge3d4493

