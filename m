Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaHCUrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 16:47:06 -0400
Received: from mx02.posteo.de ([89.146.194.165]:42229 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbaHCUrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 16:47:04 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] staging: lustre: use NULL instead of 0 for non-integers
Date: Sun,  3 Aug 2014 22:45:36 +0200
Message-Id: <1407098737-27911-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes sparse errors where 0 is used for non-integers.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
applies to -next20140802

 drivers/staging/lustre/lnet/lnet/api-ni.c          |    4 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |    2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    2 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |    2 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |   44 ++++++++++----------
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    2 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |    2 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |    4 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |    4 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |    2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |    6 +--
 11 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index f4a2c65..b28734a 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -1662,7 +1662,7 @@ lnet_destroy_ping_info(void)
 int
 lnet_ping_target_init(void)
 {
-	lnet_md_t	 md = {0};
+	lnet_md_t	 md = { NULL };
 	lnet_handle_me_t  meh;
 	lnet_process_id_t id;
 	int	       rc;
@@ -1770,7 +1770,7 @@ lnet_ping (lnet_process_id_t id, int timeout_ms, lnet_process_id_t *ids, int n_i
 	lnet_handle_eq_t     eqh;
 	lnet_handle_md_t     mdh;
 	lnet_event_t	 event;
-	lnet_md_t	    md = {0};
+	lnet_md_t	    md = { NULL };
 	int		  which;
 	int		  unlinked = 0;
 	int		  replied = 0;
diff --git a/drivers/staging/lustre/lustre/fld/fld_request.c b/drivers/staging/lustre/lustre/fld/fld_request.c
index 4efded9..8e512f9 100644
--- a/drivers/staging/lustre/lustre/fld/fld_request.c
+++ b/drivers/staging/lustre/lustre/fld/fld_request.c
@@ -168,7 +168,7 @@ struct lu_fld_hash fld_hash[] = {
 		.fh_scan_func = fld_rrb_scan
 	},
 	{
-		0,
+		NULL,
 	}
 };
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index e0d8f15..0367f5a 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -152,7 +152,7 @@ static void ll_free_sbi(struct super_block *sb)
 static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				    struct vfsmount *mnt)
 {
-	struct inode *root = 0;
+	struct inode *root = NULL;
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
 	struct obd_device *obd;
 	struct obd_capa *oc = NULL;
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 13586c5..77f68b5 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -843,7 +843,7 @@ static struct lprocfs_vars lprocfs_llite_obd_vars[] = {
 	{ "default_cookiesize", &ll_defult_cookiesize_fops, NULL, 0 },
 	{ "sbi_flags",	      &ll_sbi_flags_fops, NULL, 0 },
 	{ "xattr_cache",      &ll_xattr_cache_fops, NULL, 0 },
-	{ 0 }
+	{ NULL }
 };
 
 #define MAX_STRING_SIZE 128
diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index e6af825..f266e95 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -172,39 +172,39 @@ LPROC_SEQ_FOPS_RW_TYPE(mdc, import);
 LPROC_SEQ_FOPS_RW_TYPE(mdc, pinger_recov);
 
 static struct lprocfs_vars lprocfs_mdc_obd_vars[] = {
-	{ "uuid",	    &mdc_uuid_fops,		0, 0 },
-	{ "ping",	    &mdc_ping_fops,		0, 0222 },
-	{ "connect_flags",  &mdc_connect_flags_fops,	0, 0 },
-	{ "blocksize",      &mdc_blksize_fops,		0, 0 },
-	{ "kbytestotal",    &mdc_kbytestotal_fops,	0, 0 },
-	{ "kbytesfree",     &mdc_kbytesfree_fops,	0, 0 },
-	{ "kbytesavail",    &mdc_kbytesavail_fops,	0, 0 },
-	{ "filestotal",     &mdc_filestotal_fops,	0, 0 },
-	{ "filesfree",      &mdc_filesfree_fops,	0, 0 },
-	/*{ "filegroups",      lprocfs_rd_filegroups,  0, 0 },*/
-	{ "mds_server_uuid", &mdc_server_uuid_fops,	0, 0 },
-	{ "mds_conn_uuid",  &mdc_conn_uuid_fops,	0, 0 },
+	{ "uuid",	    &mdc_uuid_fops,		NULL, 0 },
+	{ "ping",	    &mdc_ping_fops,		NULL, 0222 },
+	{ "connect_flags",  &mdc_connect_flags_fops,	NULL, 0 },
+	{ "blocksize",      &mdc_blksize_fops,		NULL, 0 },
+	{ "kbytestotal",    &mdc_kbytestotal_fops,	NULL, 0 },
+	{ "kbytesfree",     &mdc_kbytesfree_fops,	NULL, 0 },
+	{ "kbytesavail",    &mdc_kbytesavail_fops,	NULL, 0 },
+	{ "filestotal",     &mdc_filestotal_fops,	NULL, 0 },
+	{ "filesfree",      &mdc_filesfree_fops,	NULL, 0 },
+	/*{ "filegroups",      lprocfs_rd_filegroups,  NULL, 0 },*/
+	{ "mds_server_uuid", &mdc_server_uuid_fops,	NULL, 0 },
+	{ "mds_conn_uuid",  &mdc_conn_uuid_fops,	NULL, 0 },
 	/*
 	 * FIXME: below proc entry is provided, but not in used, instead
 	 * sbi->sb_md_brw_size is used, the per obd variable should be used
 	 * when CMD is enabled, and dir pages are managed in MDC layer.
 	 * Remember to enable proc write function.
 	 */
-	{ "max_pages_per_rpc",  &mdc_obd_max_pages_per_rpc_fops, 0, 0 },
-	{ "max_rpcs_in_flight", &mdc_max_rpcs_in_flight_fops, 0, 0 },
-	{ "timeouts",		&mdc_timeouts_fops,    0, 0 },
-	{ "import",		&mdc_import_fops, 0 },
-	{ "state",		&mdc_state_fops, 0, 0 },
-	{ "hsm_nl",		&mdc_kuc_fops, 0, 0200 },
-	{ "pinger_recov",	&mdc_pinger_recov_fops, 0, 0 },
-	{ 0 }
+	{ "max_pages_per_rpc",  &mdc_obd_max_pages_per_rpc_fops, NULL, 0 },
+	{ "max_rpcs_in_flight", &mdc_max_rpcs_in_flight_fops, NULL, 0 },
+	{ "timeouts",		&mdc_timeouts_fops,    NULL, 0 },
+	{ "import",		&mdc_import_fops, NULL, 0 },
+	{ "state",		&mdc_state_fops, NULL, 0 },
+	{ "hsm_nl",		&mdc_kuc_fops, NULL, 0200 },
+	{ "pinger_recov",	&mdc_pinger_recov_fops, NULL, 0 },
+	{ NULL }
 };
 
 LPROC_SEQ_FOPS_RO_TYPE(mdc, numrefs);
 
 static struct lprocfs_vars lprocfs_mdc_module_vars[] = {
-	{ "num_refs",	&mdc_numrefs_fops,     0, 0 },
-	{ 0 }
+	{ "num_refs",	&mdc_numrefs_fops,     NULL, 0 },
+	{ NULL }
 };
 
 void lprocfs_mdc_init_vars(struct lprocfs_static_vars *lvars)
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index 46a7d76..f520591 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -197,7 +197,7 @@ struct config_llog_data *do_config_log_add(struct obd_device *obd,
 	int		      rc;
 
 	CDEBUG(D_MGC, "do adding config log %s:%p\n", logname,
-	       cfg ? cfg->cfg_instance : 0);
+	       cfg ? cfg->cfg_instance : NULL);
 
 	OBD_ALLOC(cld, sizeof(*cld) + strlen(logname) + 1);
 	if (!cld)
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 1de1c65..9ce3d36 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -328,7 +328,7 @@ struct lprocfs_vars lprocfs_base[] = {
 	{ "jobid_var", &obd_proc_jobid_var_fops },
 	{ .name =	"jobid_name",
 	  .fops =	&obd_proc_jobid_name_fops},
-	{ 0 }
+	{ NULL }
 };
 
 static void *obd_device_list_seq_start(struct seq_file *p, loff_t *pos)
diff --git a/drivers/staging/lustre/lustre/obdclass/llog_test.c b/drivers/staging/lustre/lustre/obdclass/llog_test.c
index 6791d02..1acd867 100644
--- a/drivers/staging/lustre/lustre/obdclass/llog_test.c
+++ b/drivers/staging/lustre/lustre/obdclass/llog_test.c
@@ -940,8 +940,8 @@ cleanup_ctxt:
 }
 
 #if defined (CONFIG_PROC_FS)
-static struct lprocfs_vars lprocfs_llog_test_obd_vars[] = { {0} };
-static struct lprocfs_vars lprocfs_llog_test_module_vars[] = { {0} };
+static struct lprocfs_vars lprocfs_llog_test_obd_vars[] = { {NULL} };
+static struct lprocfs_vars lprocfs_llog_test_module_vars[] = { {NULL} };
 static void lprocfs_llog_test_init_vars(struct lprocfs_static_vars *lvars)
 {
     lvars->module_vars  = lprocfs_llog_test_module_vars;
diff --git a/drivers/staging/lustre/lustre/obdclass/obd_config.c b/drivers/staging/lustre/lustre/obdclass/obd_config.c
index 3acb1a8..d4410a2 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_config.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_config.c
@@ -1161,7 +1161,7 @@ int class_process_config(struct lustre_cfg *lcfg)
 		char *tmp;
 		/* llite has no obd */
 		if ((class_match_param(lustre_cfg_string(lcfg, 1),
-				       PARAM_LLITE, 0) == 0) &&
+				       PARAM_LLITE, NULL) == 0) &&
 		    client_process_config) {
 			err = (*client_process_config)(lcfg);
 			GOTO(out, err);
@@ -1303,7 +1303,7 @@ int class_process_proc_param(char *prefix, struct lprocfs_vars *lvars,
 		/* Search proc entries */
 		while (lvars[j].name) {
 			var = &lvars[j];
-			if (class_match_param(key, (char *)var->name, 0) == 0 &&
+			if (class_match_param(key, (char *)var->name, NULL) == 0 &&
 			    keylen == strlen(var->name)) {
 				matched++;
 				rc = -EROFS;
diff --git a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
index b3428d9..f1847f3 100644
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -3113,7 +3113,7 @@ static struct obd_ops echo_client_obd_ops = {
 
 int echo_client_init(void)
 {
-	struct lprocfs_static_vars lvars = { 0 };
+	struct lprocfs_static_vars lvars = { NULL };
 	int rc;
 
 	lprocfs_echo_init_vars(&lvars);
diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index 5028e77..fb0d9fb 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -3421,7 +3421,7 @@ static int brw_queue_work(const struct lu_env *env, void *data)
 
 int osc_setup(struct obd_device *obd, struct lustre_cfg *lcfg)
 {
-	struct lprocfs_static_vars lvars = { 0 };
+	struct lprocfs_static_vars lvars = { NULL };
 	struct client_obd	  *cli = &obd->u.cli;
 	void		       *handler;
 	int			rc;
@@ -3545,7 +3545,7 @@ int osc_cleanup(struct obd_device *obd)
 
 int osc_process_config_base(struct obd_device *obd, struct lustre_cfg *lcfg)
 {
-	struct lprocfs_static_vars lvars = { 0 };
+	struct lprocfs_static_vars lvars = { NULL };
 	int rc = 0;
 
 	lprocfs_osc_init_vars(&lvars);
@@ -3612,7 +3612,7 @@ extern struct lock_class_key osc_ast_guard_class;
 
 int __init osc_init(void)
 {
-	struct lprocfs_static_vars lvars = { 0 };
+	struct lprocfs_static_vars lvars = { NULL };
 	int rc;
 
 	/* print an address of _any_ initialized kernel symbol from this
-- 
1.7.10.4

