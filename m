Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaHUN3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:29:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53342 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbaHUN3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:29:15 -0400
Date: Thu, 21 Aug 2014 18:59:07 +0530
From: Hema Prathaban <hemaklnce@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com
Subject: [PATCH] staging: lustre: lustre: ptlrpc: Fix space required
Message-ID: <20140821132907.GA4118@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl issue
Error: Required space after " '+' ',' '=' '(' ' if' "

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c       |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c       |  4 ++--
 drivers/staging/lustre/lustre/ptlrpc/import.c       |  8 ++++----
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c  | 16 ++++++++--------
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c |  6 +++---
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c     |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c   |  6 +++---
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c     |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c      |  2 +-
 9 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 8fa9b71..a327d19 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -289,7 +289,7 @@ static void ptlrpc_at_adj_net_latency(struct ptlrpc_request *req,
 	at = &req->rq_import->imp_at;
 
 	/* Network latency is total time less server processing time */
-	nl = max_t(int, now - req->rq_sent - service_time, 0) +1/*st rounding*/;
+	nl = max_t(int, now - req->rq_sent - service_time, 0) + 1/*st rounding*/;
 	if (service_time > now - req->rq_sent + 3 /* bz16408 */)
 		CWARN("Reported service time %u > total measured time "
 		      CFS_DURATION_T"\n", service_time,
diff --git a/drivers/staging/lustre/lustre/ptlrpc/events.c b/drivers/staging/lustre/lustre/ptlrpc/events.c
index c3ec21d..9f5af45 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/events.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/events.c
@@ -186,7 +186,7 @@ void client_bulk_callback(lnet_event_t *ev)
 	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB, CFS_FAIL_ONCE))
 		ev->status = -EIO;
 
-	if (CFS_FAIL_CHECK_ORSET(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2,CFS_FAIL_ONCE))
+	if (CFS_FAIL_CHECK_ORSEuT(OBD_FAIL_PTLRPC_CLIENT_BULK_CB2, CFS_FAIL_ONCE))
 		ev->status = -EIO;
 
 	CDEBUG((ev->status == 0) ? D_NET : D_ERROR,
@@ -481,7 +481,7 @@ int ptlrpc_uuid_to_peer(struct obd_uuid *uuid,
 		}
 	}
 
-	CDEBUG(D_NET,"%s->%s\n", uuid->uuid, libcfs_id2str(*peer));
+	CDEBUG(D_NET, "%s->%s\n", uuid->uuid, libcfs_id2str(*peer));
 	return rc;
 }
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 771b213..5b5c049 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -297,7 +297,7 @@ void ptlrpc_invalidate_import(struct obd_import *imp)
 			timeout = 1;
 		}
 
-		CDEBUG(D_RPCTRACE,"Sleeping %d sec for inflight to error out\n",
+		CDEBUG(D_RPCTRACE, "Sleeping %d sec for inflight to error out\n",
 		       timeout);
 
 		/* Wait for all requests to error out and call completion
@@ -843,7 +843,7 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 	if ((ocd->ocd_connect_flags & imp->imp_connect_flags_orig) !=
 	    ocd->ocd_connect_flags) {
 		CERROR("%s: Server didn't granted asked subset of flags: asked=%#llx grranted=%#llx\n",
-		       imp->imp_obd->obd_name,imp->imp_connect_flags_orig,
+		       imp->imp_obd->obd_name, imp->imp_connect_flags_orig,
 		       ocd->ocd_connect_flags);
 		GOTO(out, rc = -EPROTO);
 	}
@@ -921,7 +921,7 @@ static int ptlrpc_connect_interpret(const struct lu_env *env,
 			 * participate since we can reestablish all of our state
 			 * with server again */
 			if ((MSG_CONNECT_RECOVERING & msg_flags)) {
-				CDEBUG(level,"%s@%s changed server handle from %#llx to %#llx but is still in recovery\n",
+				CDEBUG(level, "%s@%s changed server handle from %#llx to %#llx but is still in recovery\n",
 				       obd2cli_tgt(imp->imp_obd),
 				       imp->imp_connection->c_remote_uuid.uuid,
 				       imp->imp_remote_handle.cookie,
@@ -1103,7 +1103,7 @@ finish:
 			 * Enforce ADLER for backward compatibility*/
 			cli->cl_supp_cksum_types = OBD_CKSUM_ADLER;
 		}
-		cli->cl_cksum_type =cksum_type_select(cli->cl_supp_cksum_types);
+		cli->cl_cksum_type = cksum_type_select(cli->cl_supp_cksum_types);
 
 		if (ocd->ocd_connect_flags & OBD_CONNECT_BRW_SIZE)
 			cli->cl_max_pages_per_rpc =
diff --git a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
index 6a1ab5c..ab2bd0d 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/llog_client.c
@@ -151,7 +151,7 @@ static int llog_client_destroy(const struct lu_env *env,
 					LUSTRE_LOG_VERSION,
 					LLOG_ORIGIN_HANDLE_DESTROY);
 	if (req == NULL)
-		GOTO(err_exit, rc =-ENOMEM);
+		GOTO(err_exit, rc = -ENOMEM);
 
 	body = req_capsule_client_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	body->lgd_logid = loghandle->lgh_id;
@@ -187,7 +187,7 @@ static int llog_client_next_block(const struct lu_env *env,
 					LUSTRE_LOG_VERSION,
 					LLOG_ORIGIN_HANDLE_NEXT_BLOCK);
 	if (req == NULL)
-		GOTO(err_exit, rc =-ENOMEM);
+		GOTO(err_exit, rc = -ENOMEM);
 
 	body = req_capsule_client_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	body->lgd_logid = loghandle->lgh_id;
@@ -206,12 +206,12 @@ static int llog_client_next_block(const struct lu_env *env,
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	if (body == NULL)
-		GOTO(out, rc =-EFAULT);
+		GOTO(out, rc = -EFAULT);
 
 	/* The log records are swabbed as they are processed */
 	ptr = req_capsule_server_get(&req->rq_pill, &RMF_EADATA);
 	if (ptr == NULL)
-		GOTO(out, rc =-EFAULT);
+		GOTO(out, rc = -EFAULT);
 
 	*cur_idx = body->lgd_saved_index;
 	*cur_offset = body->lgd_cur_offset;
@@ -257,11 +257,11 @@ static int llog_client_prev_block(const struct lu_env *env,
 
 	body = req_capsule_server_get(&req->rq_pill, &RMF_LLOGD_BODY);
 	if (body == NULL)
-		GOTO(out, rc =-EFAULT);
+		GOTO(out, rc = -EFAULT);
 
 	ptr = req_capsule_server_get(&req->rq_pill, &RMF_EADATA);
 	if (ptr == NULL)
-		GOTO(out, rc =-EFAULT);
+		GOTO(out, rc = -EFAULT);
 
 	memcpy(buf, ptr, len);
 out:
@@ -282,7 +282,7 @@ static int llog_client_read_header(const struct lu_env *env,
 	int		    rc;
 
 	LLOG_CLIENT_ENTRY(handle->lgh_ctxt, imp);
-	req = ptlrpc_request_alloc_pack(imp,&RQF_LLOG_ORIGIN_HANDLE_READ_HEADER,
+	req = ptlrpc_request_alloc_pack(imp, &RQF_LLOG_ORIGIN_HANDLE_READ_HEADER,
 					LUSTRE_LOG_VERSION,
 					LLOG_ORIGIN_HANDLE_READ_HEADER);
 	if (req == NULL)
@@ -300,7 +300,7 @@ static int llog_client_read_header(const struct lu_env *env,
 
 	hdr = req_capsule_server_get(&req->rq_pill, &RMF_LLOG_LOG_HDR);
 	if (hdr == NULL)
-		GOTO(out, rc =-EFAULT);
+		GOTO(out, rc = -EFAULT);
 
 	memcpy(handle->lgh_hdr, hdr, sizeof(*hdr));
 	handle->lgh_last_idx = handle->lgh_hdr->llh_tail.lrt_index;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index bc22030..7b952e8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -119,7 +119,7 @@ struct ll_rpc_opcode {
 	{ OBD_IDX_READ,	    "dt_index_read" },
 	{ LLOG_ORIGIN_HANDLE_CREATE,	 "llog_origin_handle_open" },
 	{ LLOG_ORIGIN_HANDLE_NEXT_BLOCK, "llog_origin_handle_next_block" },
-	{ LLOG_ORIGIN_HANDLE_READ_HEADER,"llog_origin_handle_read_header" },
+	{ LLOG_ORIGIN_HANDLE_READ_HEADER, "llog_origin_handle_read_header" },
 	{ LLOG_ORIGIN_HANDLE_WRITE_REC,  "llog_origin_handle_write_rec" },
 	{ LLOG_ORIGIN_HANDLE_CLOSE,      "llog_origin_handle_close" },
 	{ LLOG_ORIGIN_CONNECT,	   "llog_origin_connect" },
@@ -130,7 +130,7 @@ struct ll_rpc_opcode {
 	{ QUOTA_DQREL,      "quota_release" },
 	{ SEQ_QUERY,	"seq_query" },
 	{ SEC_CTX_INIT,     "sec_ctx_init" },
-	{ SEC_CTX_INIT_CONT,"sec_ctx_init_cont" },
+	{ SEC_CTX_INIT_CONT, "sec_ctx_init_cont" },
 	{ SEC_CTX_FINI,     "sec_ctx_fini" },
 	{ FLD_QUERY,	"fld_query" },
 	{ UPDATE_OBJ,	    "update_obj" },
@@ -194,7 +194,7 @@ void ptlrpc_lprocfs_register(struct proc_dir_entry *root, char *dir,
 	LASSERT(*procroot_ret == NULL);
 	LASSERT(*stats_ret == NULL);
 
-	svc_stats = lprocfs_alloc_stats(EXTRA_MAX_OPCODES+LUSTRE_MAX_OPCODES,0);
+	svc_stats = lprocfs_alloc_stats(EXTRA_MAX_OPCODES+LUSTRE_MAX_OPCODES, 0);
 	if (svc_stats == NULL)
 		return;
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 874789b..3b7ab82 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -365,7 +365,7 @@ static void enc_pools_insert(struct page ***pools, int npools, int npages)
 	 */
 	cur_npools = (page_pools.epp_total_pages + PAGES_PER_POOL - 1) /
 		     PAGES_PER_POOL;
-	end_npools = (page_pools.epp_total_pages + npages + PAGES_PER_POOL -1) /
+	end_npools = (page_pools.epp_total_pages + npages + PAGES_PER_POOL - 1) /
 		     PAGES_PER_POOL;
 	LASSERT(end_npools <= page_pools.epp_max_pools);
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index 8ef666b..c9e9da7 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -746,7 +746,7 @@ void sptlrpc_conf_log_update_begin(const char *logname)
 
 	conf = sptlrpc_conf_get(fsname, 0);
 	if (conf) {
-		if(conf->sc_local) {
+		if (conf->sc_local) {
 			LASSERT(conf->sc_updated == 0);
 			sptlrpc_conf_free_rsets(conf);
 		}
@@ -908,7 +908,7 @@ void sptlrpc_conf_client_adapt(struct obd_device *obd)
 	struct obd_import  *imp;
 
 	LASSERT(strcmp(obd->obd_type->typ_name, LUSTRE_MDC_NAME) == 0 ||
-		strcmp(obd->obd_type->typ_name, LUSTRE_OSC_NAME) ==0);
+		strcmp(obd->obd_type->typ_name, LUSTRE_OSC_NAME) == 0);
 	CDEBUG(D_SEC, "obd %s\n", obd->u.cli.cl_target_uuid.uuid);
 
 	/* serialize with connect/disconnect import */
@@ -1201,7 +1201,7 @@ int sptlrpc_conf_target_get_rules(struct obd_device *obd,
 	conf_tgt = sptlrpc_conf_get_tgt(conf, obd->obd_name, 0);
 
 	rc = sptlrpc_rule_set_extract(&conf->sc_rset,
-				      conf_tgt ? &conf_tgt->sct_rset: NULL,
+				      conf_tgt ? &conf_tgt->sct_rset : NULL,
 				      LUSTRE_SP_ANY, sp_dst, rset);
 out:
 	mutex_unlock(&sptlrpc_conf_lock);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
index a477914..7f17767 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
@@ -471,5 +471,5 @@ void sptlrpc_null_fini(void)
 
 	rc = sptlrpc_unregister_policy(&null_policy);
 	if (rc)
-		CERROR("failed to unregister %s: %d\n", null_policy.sp_name,rc);
+		CERROR("failed to unregister %s: %d\n", null_policy.sp_name, rc);
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index c88eae27b..b1908cc 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -1896,7 +1896,7 @@ ptlrpc_server_handle_request(struct ptlrpc_service_part *svcpt,
 		libcfs_debug_dumplog();
 
 	do_gettimeofday(&work_start);
-	timediff = cfs_timeval_sub(&work_start, &request->rq_arrival_time,NULL);
+	timediff = cfs_timeval_sub(&work_start, &request->rq_arrival_time, NULL);
 	if (likely(svc->srv_stats != NULL)) {
 		lprocfs_counter_add(svc->srv_stats, PTLRPC_REQWAIT_CNTR,
 				    timediff);
-- 
1.9.1

