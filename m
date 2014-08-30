Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaH3VNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:13:40 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51523 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaH3VNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:13:21 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 03/12] staging/lustre/obdecho: remove #if 0-ed out regions
Date: Sat, 30 Aug 2014 17:12:42 -0400
Message-Id: <1409433171-23572-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
References: <1409433171-23572-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

The landing of clio #if 0-ed out some regions of echo_client.c. Just
remove these regions entirely.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/5580
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2675
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../staging/lustre/lustre/obdecho/echo_client.c    | 50 ----------------------
 1 file changed, 50 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index 68a5ed1..98e4290 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -93,16 +93,6 @@ struct echo_lock {
 	atomic_t	   el_refcount;
 };
 
-struct echo_io {
-	struct cl_io_slice     ei_cl;
-};
-
-#if 0
-struct echo_req {
-	struct cl_req_slice er_cl;
-};
-#endif
-
 static int echo_client_setup(const struct lu_env *env,
 			     struct obd_device *obddev,
 			     struct lustre_cfg *lcfg);
@@ -200,7 +190,6 @@ static struct kmem_cache *echo_lock_kmem;
 static struct kmem_cache *echo_object_kmem;
 static struct kmem_cache *echo_thread_kmem;
 static struct kmem_cache *echo_session_kmem;
-//static struct kmem_cache *echo_req_kmem;
 
 static struct lu_kmem_descr echo_caches[] = {
 	{
@@ -223,13 +212,6 @@ static struct lu_kmem_descr echo_caches[] = {
 		.ckd_name  = "echo_session_kmem",
 		.ckd_size  = sizeof (struct echo_session_info)
 	},
-#if 0
-	{
-		.ckd_cache = &echo_req_kmem,
-		.ckd_name  = "echo_req_kmem",
-		.ckd_size  = sizeof (struct echo_req)
-	},
-#endif
 	{
 		.ckd_cache = NULL
 	}
@@ -2100,37 +2082,11 @@ static int echo_client_connect(const struct lu_env *env,
 
 static int echo_client_disconnect(struct obd_export *exp)
 {
-#if 0
-	struct obd_device      *obd;
-	struct echo_client_obd *ec;
-	struct ec_lock	 *ecl;
-#endif
 	int		     rc;
 
 	if (exp == NULL)
 		GOTO(out, rc = -EINVAL);
 
-#if 0
-	obd = exp->exp_obd;
-	ec = &obd->u.echo_client;
-
-	/* no more contention on export's lock list */
-	while (!list_empty (&exp->exp_ec_data.eced_locks)) {
-		ecl = list_entry (exp->exp_ec_data.eced_locks.next,
-				      struct ec_lock, ecl_exp_chain);
-		list_del (&ecl->ecl_exp_chain);
-
-		rc = obd_cancel(ec->ec_exp, ecl->ecl_object->eco_lsm,
-				 ecl->ecl_mode, &ecl->ecl_lock_handle);
-
-		CDEBUG (D_INFO, "Cancel lock on object %#llx on disconnect "
-			"(%d)\n", ecl->ecl_object->eco_id, rc);
-
-		echo_put_object (ecl->ecl_object);
-		OBD_FREE (ecl, sizeof (*ecl));
-	}
-#endif
-
 	rc = class_disconnect(exp);
 	GOTO(out, rc);
  out:
@@ -2139,12 +2095,6 @@ static int echo_client_disconnect(struct obd_export *exp)
 
 static struct obd_ops echo_client_obd_ops = {
 	.o_owner       = THIS_MODULE,
-
-#if 0
-	.o_setup       = echo_client_setup,
-	.o_cleanup     = echo_client_cleanup,
-#endif
-
 	.o_iocontrol   = echo_client_iocontrol,
 	.o_connect     = echo_client_connect,
 	.o_disconnect  = echo_client_disconnect
-- 
1.9.3

