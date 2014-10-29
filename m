Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbaJ2TmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:42:04 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:38319 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaJ2Tl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:41:59 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, oleg.drokin@intel.com, andreas.dilger@intel.com,
        heenasirwani@gmail.com, bergwolf@gmail.com, amir.shehata@intel.com,
        gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/02] staging:lustre:lnet:selftest: fix sparse warnings
Date: Wed, 29 Oct 2014 23:41:49 +0400
Message-Id: <b7cad42e96c92c4651cd40bfba5ad0835e16dd27.1414609881.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1414609881.git.antonysaraev@gmail.com>
References: <cover.1414609881.git.antonysaraev@gmail.com>
In-Reply-To: <cover.1414609881.git.antonysaraev@gmail.com>
References: <cover.1414609881.git.antonysaraev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warnings: symbol X was not declared. Should it be static?
Some functions used only in files where they are declared. They can
be static.

Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
---
 drivers/staging/lustre/lnet/selftest/conctl.c    | 34 ++++++++--------
 drivers/staging/lustre/lnet/selftest/conrpc.c    | 20 +++++-----
 drivers/staging/lustre/lnet/selftest/framework.c | 50 ++++++++++++------------
 drivers/staging/lustre/lnet/selftest/module.c    |  4 +-
 drivers/staging/lustre/lnet/selftest/rpc.c       | 34 ++++++++--------
 drivers/staging/lustre/lnet/selftest/timer.c     |  8 ++--
 6 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/staging/lustre/lnet/selftest/conctl.c b/drivers/staging/lustre/lnet/selftest/conctl.c
index ae7b0fc..5bc6153 100644
--- a/drivers/staging/lustre/lnet/selftest/conctl.c
+++ b/drivers/staging/lustre/lnet/selftest/conctl.c
@@ -45,7 +45,7 @@
 #include "../../include/linux/lnet/lnetst.h"
 #include "console.h"
 
-int
+static int
 lst_session_new_ioctl(lstio_session_new_args_t *args)
 {
 	char      *name;
@@ -82,7 +82,7 @@ lst_session_new_ioctl(lstio_session_new_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_session_end_ioctl(lstio_session_end_args_t *args)
 {
 	if (args->lstio_ses_key != console_session.ses_key)
@@ -91,7 +91,7 @@ lst_session_end_ioctl(lstio_session_end_args_t *args)
 	return lstcon_session_end();
 }
 
-int
+static int
 lst_session_info_ioctl(lstio_session_info_args_t *args)
 {
 	/* no checking of key */
@@ -113,7 +113,7 @@ lst_session_info_ioctl(lstio_session_info_args_t *args)
 				   args->lstio_ses_nmlen);
 }
 
-int
+static int
 lst_debug_ioctl(lstio_debug_args_t *args)
 {
 	char   *name   = NULL;
@@ -194,7 +194,7 @@ out:
 	return rc;
 }
 
-int
+static int
 lst_group_add_ioctl(lstio_group_add_args_t *args)
 {
 	char	   *name;
@@ -228,7 +228,7 @@ lst_group_add_ioctl(lstio_group_add_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_group_del_ioctl(lstio_group_del_args_t *args)
 {
 	int     rc;
@@ -262,7 +262,7 @@ lst_group_del_ioctl(lstio_group_del_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_group_update_ioctl(lstio_group_update_args_t *args)
 {
 	int     rc;
@@ -320,7 +320,7 @@ lst_group_update_ioctl(lstio_group_update_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_nodes_add_ioctl(lstio_group_nodes_args_t *args)
 {
 	unsigned feats;
@@ -365,7 +365,7 @@ lst_nodes_add_ioctl(lstio_group_nodes_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_group_list_ioctl(lstio_group_list_args_t *args)
 {
 	if (args->lstio_grp_key != console_session.ses_key)
@@ -382,7 +382,7 @@ lst_group_list_ioctl(lstio_group_list_args_t *args)
 			      args->lstio_grp_namep);
 }
 
-int
+static int
 lst_group_info_ioctl(lstio_group_info_args_t *args)
 {
 	char	   *name;
@@ -446,7 +446,7 @@ lst_group_info_ioctl(lstio_group_info_args_t *args)
 	return 0;
 }
 
-int
+static int
 lst_batch_add_ioctl(lstio_batch_add_args_t *args)
 {
 	int	     rc;
@@ -480,7 +480,7 @@ lst_batch_add_ioctl(lstio_batch_add_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_batch_run_ioctl(lstio_batch_run_args_t *args)
 {
 	int	     rc;
@@ -515,7 +515,7 @@ lst_batch_run_ioctl(lstio_batch_run_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_batch_stop_ioctl(lstio_batch_stop_args_t *args)
 {
 	int	     rc;
@@ -551,7 +551,7 @@ lst_batch_stop_ioctl(lstio_batch_stop_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_batch_query_ioctl(lstio_batch_query_args_t *args)
 {
 	char   *name;
@@ -593,7 +593,7 @@ lst_batch_query_ioctl(lstio_batch_query_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_batch_list_ioctl(lstio_batch_list_args_t *args)
 {
 	if (args->lstio_bat_key != console_session.ses_key)
@@ -610,7 +610,7 @@ lst_batch_list_ioctl(lstio_batch_list_args_t *args)
 			      args->lstio_bat_namep);
 }
 
-int
+static int
 lst_batch_info_ioctl(lstio_batch_info_args_t *args)
 {
 	char	   *name;
@@ -675,7 +675,7 @@ lst_batch_info_ioctl(lstio_batch_info_args_t *args)
 	return rc;
 }
 
-int
+static int
 lst_stat_query_ioctl(lstio_stat_args_t *args)
 {
 	int	     rc;
diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index a3a60d6..9999b0d 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -88,7 +88,7 @@ lstcon_rpc_done(srpc_client_rpc_t *rpc)
 	spin_unlock(&rpc->crpc_lock);
 }
 
-int
+static int
 lstcon_rpc_init(lstcon_node_t *nd, int service, unsigned feats,
 		int bulk_npg, int bulk_len, int embedded, lstcon_rpc_t *crpc)
 {
@@ -113,7 +113,7 @@ lstcon_rpc_init(lstcon_node_t *nd, int service, unsigned feats,
 	return 0;
 }
 
-int
+static int
 lstcon_rpc_prep(lstcon_node_t *nd, int service, unsigned feats,
 		int bulk_npg, int bulk_len, lstcon_rpc_t **crpcpp)
 {
@@ -182,7 +182,7 @@ lstcon_rpc_put(lstcon_rpc_t *crpc)
 	atomic_dec(&console_session.ses_rpc_counter);
 }
 
-void
+static void
 lstcon_rpc_post(lstcon_rpc_t *crpc)
 {
 	lstcon_rpc_trans_t *trans = crpc->crp_trans;
@@ -383,7 +383,7 @@ lstcon_rpc_trans_postwait(lstcon_rpc_trans_t *trans, int timeout)
 	return rc;
 }
 
-int
+static int
 lstcon_rpc_get_reply(lstcon_rpc_t *crpc, srpc_msg_t **msgpp)
 {
 	lstcon_node_t	*nd  = crpc->crp_node;
@@ -718,7 +718,7 @@ lstcon_next_id(int idx, int nkiov, lnet_kiov_t *kiov)
 	return &pid[idx % SFW_ID_PER_PAGE];
 }
 
-int
+static int
 lstcon_dstnodes_prep(lstcon_group_t *grp, int idx,
 		     int dist, int span, int nkiov, lnet_kiov_t *kiov)
 {
@@ -772,7 +772,7 @@ lstcon_dstnodes_prep(lstcon_group_t *grp, int idx,
 	return 0;
 }
 
-int
+static int
 lstcon_pingrpc_prep(lst_test_ping_param_t *param, srpc_test_reqst_t *req)
 {
 	test_ping_req_t *prq = &req->tsr_u.ping;
@@ -783,7 +783,7 @@ lstcon_pingrpc_prep(lst_test_ping_param_t *param, srpc_test_reqst_t *req)
 	return 0;
 }
 
-int
+static int
 lstcon_bulkrpc_v0_prep(lst_test_bulk_param_t *param, srpc_test_reqst_t *req)
 {
 	test_bulk_req_t *brq = &req->tsr_u.bulk_v0;
@@ -795,7 +795,7 @@ lstcon_bulkrpc_v0_prep(lst_test_bulk_param_t *param, srpc_test_reqst_t *req)
 	return 0;
 }
 
-int
+static int
 lstcon_bulkrpc_v1_prep(lst_test_bulk_param_t *param, srpc_test_reqst_t *req)
 {
 	test_bulk_req_v1_t *brq = &req->tsr_u.bulk_v1;
@@ -915,7 +915,7 @@ lstcon_testrpc_prep(lstcon_node_t *nd, int transop, unsigned feats,
 	return rc;
 }
 
-int
+static int
 lstcon_sesnew_stat_reply(lstcon_rpc_trans_t *trans,
 			 lstcon_node_t *nd, srpc_msg_t *reply)
 {
@@ -1162,7 +1162,7 @@ lstcon_rpc_trans_ndlist(struct list_head *ndlist,
 	return rc;
 }
 
-void
+static void
 lstcon_rpc_pinger(void *arg)
 {
 	stt_timer_t	*ptimer = (stt_timer_t *)arg;
diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index df04ab7..82cc94b 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -156,7 +156,7 @@ sfw_register_test (srpc_service_t *service, sfw_test_client_ops_t *cliops)
 	return 0;
 }
 
-void
+static void
 sfw_add_session_timer (void)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
@@ -176,7 +176,7 @@ sfw_add_session_timer (void)
 	return;
 }
 
-int
+static int
 sfw_del_session_timer (void)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
@@ -238,7 +238,7 @@ sfw_deactivate_session (void)
 }
 
 
-void
+static void
 sfw_session_expired (void *data)
 {
 	sfw_session_t *sn = data;
@@ -284,7 +284,7 @@ sfw_init_session(sfw_session_t *sn, lst_sid_t sid,
 }
 
 /* completion handler for incoming framework RPCs */
-void
+static void
 sfw_server_rpc_done(struct srpc_server_rpc *rpc)
 {
 	struct srpc_service	*sv	= rpc->srpc_scd->scd_svc;
@@ -302,7 +302,7 @@ sfw_server_rpc_done(struct srpc_server_rpc *rpc)
 	return;
 }
 
-void
+static void
 sfw_client_rpc_fini (srpc_client_rpc_t *rpc)
 {
 	LASSERT (rpc->crpc_bulk.bk_niov == 0);
@@ -325,7 +325,7 @@ sfw_client_rpc_fini (srpc_client_rpc_t *rpc)
 	spin_unlock(&sfw_data.fw_lock);
 }
 
-sfw_batch_t *
+static sfw_batch_t *
 sfw_find_batch (lst_bid_t bid)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
@@ -341,7 +341,7 @@ sfw_find_batch (lst_bid_t bid)
 	return NULL;
 }
 
-sfw_batch_t *
+static sfw_batch_t *
 sfw_bid2batch (lst_bid_t bid)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
@@ -367,7 +367,7 @@ sfw_bid2batch (lst_bid_t bid)
 	return bat;
 }
 
-int
+static int
 sfw_get_stats (srpc_stat_reqst_t *request, srpc_stat_reply_t *reply)
 {
 	sfw_session_t  *sn = sfw_data.fw_session;
@@ -479,7 +479,7 @@ sfw_make_session(srpc_mksn_reqst_t *request, srpc_mksn_reply_t *reply)
 	return 0;
 }
 
-int
+static int
 sfw_remove_session (srpc_rmsn_reqst_t *request, srpc_rmsn_reply_t *reply)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
@@ -511,7 +511,7 @@ sfw_remove_session (srpc_rmsn_reqst_t *request, srpc_rmsn_reply_t *reply)
 	return 0;
 }
 
-int
+static int
 sfw_debug_session (srpc_debug_reqst_t *request, srpc_debug_reply_t *reply)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
@@ -532,7 +532,7 @@ sfw_debug_session (srpc_debug_reqst_t *request, srpc_debug_reply_t *reply)
 	return 0;
 }
 
-void
+static void
 sfw_test_rpc_fini (srpc_client_rpc_t *rpc)
 {
 	sfw_test_unit_t     *tsu = rpc->crpc_priv;
@@ -554,7 +554,7 @@ sfw_test_buffers(sfw_test_instance_t *tsi)
 	return max(SFW_TEST_WI_MIN, nbuf + SFW_TEST_WI_EXTRA);
 }
 
-int
+static int
 sfw_load_test(struct sfw_test_instance *tsi)
 {
 	struct sfw_test_case	*tsc;
@@ -591,7 +591,7 @@ sfw_load_test(struct sfw_test_instance *tsi)
 	return 0;
 }
 
-void
+static void
 sfw_unload_test(struct sfw_test_instance *tsi)
 {
 	struct sfw_test_case *tsc = sfw_find_test_case(tsi->tsi_service);
@@ -609,7 +609,7 @@ sfw_unload_test(struct sfw_test_instance *tsi)
 	return;
 }
 
-void
+static void
 sfw_destroy_test_instance (sfw_test_instance_t *tsi)
 {
 	srpc_client_rpc_t *rpc;
@@ -643,7 +643,7 @@ clean:
 	return;
 }
 
-void
+static void
 sfw_destroy_batch (sfw_batch_t *tsb)
 {
 	sfw_test_instance_t *tsi;
@@ -682,7 +682,7 @@ sfw_destroy_session (sfw_session_t *sn)
 	return;
 }
 
-void
+static void
 sfw_unpack_addtest_req(srpc_msg_t *msg)
 {
 	srpc_test_reqst_t *req = &msg->msg_body.tes_reqst;
@@ -727,7 +727,7 @@ sfw_unpack_addtest_req(srpc_msg_t *msg)
 	return;
 }
 
-int
+static int
 sfw_add_test_instance (sfw_batch_t *tsb, srpc_server_rpc_t *rpc)
 {
 	srpc_msg_t	  *msg = &rpc->srpc_reqstbuf->buf_msg;
@@ -865,7 +865,7 @@ sfw_test_unit_done (sfw_test_unit_t *tsu)
 	return;
 }
 
-void
+static void
 sfw_test_rpc_done (srpc_client_rpc_t *rpc)
 {
 	sfw_test_unit_t     *tsu = rpc->crpc_priv;
@@ -944,7 +944,7 @@ sfw_create_test_rpc(sfw_test_unit_t *tsu, lnet_process_id_t peer,
 	return 0;
 }
 
-int
+static int
 sfw_run_test (swi_workitem_t *wi)
 {
 	sfw_test_unit_t     *tsu = wi->swi_workitem.wi_data;
@@ -994,7 +994,7 @@ test_done:
 	return 1;
 }
 
-int
+static int
 sfw_run_batch (sfw_batch_t *tsb)
 {
 	swi_workitem_t      *wi;
@@ -1072,7 +1072,7 @@ sfw_stop_batch (sfw_batch_t *tsb, int force)
 	return 0;
 }
 
-int
+static int
 sfw_query_batch (sfw_batch_t *tsb, int testidx, srpc_batch_reply_t *reply)
 {
 	sfw_test_instance_t *tsi;
@@ -1117,7 +1117,7 @@ sfw_alloc_pages(struct srpc_server_rpc *rpc, int cpt, int npages, int len,
 	return 0;
 }
 
-int
+static int
 sfw_add_test (srpc_server_rpc_t *rpc)
 {
 	sfw_session_t     *sn = sfw_data.fw_session;
@@ -1187,7 +1187,7 @@ sfw_add_test (srpc_server_rpc_t *rpc)
 	return 0;
 }
 
-int
+static int
 sfw_control_batch (srpc_batch_reqst_t *request, srpc_batch_reply_t *reply)
 {
 	sfw_session_t *sn = sfw_data.fw_session;
@@ -1228,7 +1228,7 @@ sfw_control_batch (srpc_batch_reqst_t *request, srpc_batch_reply_t *reply)
 	return 0;
 }
 
-int
+static int
 sfw_handle_server_rpc(struct srpc_server_rpc *rpc)
 {
 	struct srpc_service	*sv = rpc->srpc_scd->scd_svc;
@@ -1334,7 +1334,7 @@ sfw_handle_server_rpc(struct srpc_server_rpc *rpc)
 	return rc;
 }
 
-int
+static int
 sfw_bulk_ready(struct srpc_server_rpc *rpc, int status)
 {
 	struct srpc_service	*sv = rpc->srpc_scd->scd_svc;
diff --git a/drivers/staging/lustre/lnet/selftest/module.c b/drivers/staging/lustre/lnet/selftest/module.c
index 6dd4309..b2dd891 100644
--- a/drivers/staging/lustre/lnet/selftest/module.c
+++ b/drivers/staging/lustre/lnet/selftest/module.c
@@ -55,7 +55,7 @@ static int lst_init_step = LST_INIT_NONE;
 struct cfs_wi_sched *lst_sched_serial;
 struct cfs_wi_sched **lst_sched_test;
 
-void
+static void
 lnet_selftest_fini(void)
 {
 	int	i;
@@ -101,7 +101,7 @@ lnet_selftest_structure_assertion(void)
 	CLASSERT(sizeof(srpc_stat_reqst_t) == 28);
 }
 
-int
+static int
 lnet_selftest_init(void)
 {
 	int	nscheds;
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index a9f29d8..c9a1a45 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -87,7 +87,7 @@ void srpc_set_counters (const srpc_counters_t *cnt)
 	spin_unlock(&srpc_data.rpc_glock);
 }
 
-int
+static int
 srpc_add_bulk_page(srpc_bulk_t *bk, struct page *pg, int i, int nob)
 {
 	nob = min(nob, (int)PAGE_CACHE_SIZE);
@@ -170,7 +170,7 @@ srpc_next_id (void)
 	return id;
 }
 
-void
+static void
 srpc_init_server_rpc(struct srpc_server_rpc *rpc,
 		     struct srpc_service_cd *scd,
 		     struct srpc_buffer *buffer)
@@ -351,7 +351,7 @@ srpc_remove_service (srpc_service_t *sv)
 	return 0;
 }
 
-int
+static int
 srpc_post_passive_rdma(int portal, int local, __u64 matchbits, void *buf,
 		       int len, int options, lnet_process_id_t peer,
 		       lnet_handle_md_t *mdh, srpc_event_t *ev)
@@ -391,7 +391,7 @@ srpc_post_passive_rdma(int portal, int local, __u64 matchbits, void *buf,
 	return 0;
 }
 
-int
+static int
 srpc_post_active_rdma(int portal, __u64 matchbits, void *buf, int len,
 		      int options, lnet_process_id_t peer, lnet_nid_t self,
 		      lnet_handle_md_t *mdh, srpc_event_t *ev)
@@ -443,7 +443,7 @@ srpc_post_active_rdma(int portal, __u64 matchbits, void *buf, int len,
 	return 0;
 }
 
-int
+static int
 srpc_post_active_rqtbuf(lnet_process_id_t peer, int service, void *buf,
 			int len, lnet_handle_md_t *mdh, srpc_event_t *ev)
 {
@@ -452,7 +452,7 @@ srpc_post_active_rqtbuf(lnet_process_id_t peer, int service, void *buf,
 				     LNET_NID_ANY, mdh, ev);
 }
 
-int
+static int
 srpc_post_passive_rqtbuf(int service, int local, void *buf, int len,
 			 lnet_handle_md_t *mdh, srpc_event_t *ev)
 {
@@ -466,7 +466,7 @@ srpc_post_passive_rqtbuf(int service, int local, void *buf, int len,
 				      LNET_MD_OP_PUT, any, mdh, ev);
 }
 
-int
+static int
 srpc_service_post_buffer(struct srpc_service_cd *scd, struct srpc_buffer *buf)
 {
 	struct srpc_service	*sv = scd->scd_svc;
@@ -697,7 +697,7 @@ srpc_finish_service(struct srpc_service *sv)
 }
 
 /* called with sv->sv_lock held */
-void
+static void
 srpc_service_recycle_buffer(struct srpc_service_cd *scd, srpc_buffer_t *buf)
 {
 	if (!scd->scd_svc->sv_shuttingdown && scd->scd_buf_adjust >= 0) {
@@ -787,7 +787,7 @@ srpc_shutdown_service(srpc_service_t *sv)
 	}
 }
 
-int
+static int
 srpc_send_request (srpc_client_rpc_t *rpc)
 {
 	srpc_event_t *ev = &rpc->crpc_reqstev;
@@ -807,7 +807,7 @@ srpc_send_request (srpc_client_rpc_t *rpc)
 	return rc;
 }
 
-int
+static int
 srpc_prepare_reply (srpc_client_rpc_t *rpc)
 {
 	srpc_event_t *ev = &rpc->crpc_replyev;
@@ -831,7 +831,7 @@ srpc_prepare_reply (srpc_client_rpc_t *rpc)
 	return rc;
 }
 
-int
+static int
 srpc_prepare_bulk (srpc_client_rpc_t *rpc)
 {
 	srpc_bulk_t  *bk = &rpc->crpc_bulk;
@@ -863,7 +863,7 @@ srpc_prepare_bulk (srpc_client_rpc_t *rpc)
 	return rc;
 }
 
-int
+static int
 srpc_do_bulk (srpc_server_rpc_t *rpc)
 {
 	srpc_event_t  *ev = &rpc->srpc_ev;
@@ -891,7 +891,7 @@ srpc_do_bulk (srpc_server_rpc_t *rpc)
 }
 
 /* only called from srpc_handle_rpc */
-void
+static void
 srpc_server_rpc_done(srpc_server_rpc_t *rpc, int status)
 {
 	struct srpc_service_cd	*scd = rpc->srpc_scd;
@@ -1066,7 +1066,7 @@ srpc_handle_rpc(swi_workitem_t *wi)
 	return 0;
 }
 
-void
+static void
 srpc_client_rpc_expired (void *data)
 {
 	srpc_client_rpc_t *rpc = data;
@@ -1108,7 +1108,7 @@ srpc_add_client_rpc_timer (srpc_client_rpc_t *rpc)
  *
  * Upon exit the RPC expiry timer is not queued and the handler is not
  * running on any CPU. */
-void
+static void
 srpc_del_client_rpc_timer (srpc_client_rpc_t *rpc)
 {
 	/* timer not planted or already exploded */
@@ -1129,7 +1129,7 @@ srpc_del_client_rpc_timer (srpc_client_rpc_t *rpc)
 	}
 }
 
-void
+static void
 srpc_client_rpc_done (srpc_client_rpc_t *rpc, int status)
 {
 	swi_workitem_t *wi = &rpc->crpc_wi;
@@ -1393,7 +1393,7 @@ srpc_send_reply(struct srpc_server_rpc *rpc)
 }
 
 /* when in kernel always called with LNET_LOCK() held, and in thread context */
-void
+static void
 srpc_lnet_ev_handler(lnet_event_t *ev)
 {
 	struct srpc_service_cd	*scd;
diff --git a/drivers/staging/lustre/lnet/selftest/timer.c b/drivers/staging/lustre/lnet/selftest/timer.c
index 91d4caa..f8352c2 100644
--- a/drivers/staging/lustre/lnet/selftest/timer.c
+++ b/drivers/staging/lustre/lnet/selftest/timer.c
@@ -121,7 +121,7 @@ stt_del_timer(stt_timer_t *timer)
 }
 
 /* called with stt_data.stt_lock held */
-int
+static int
 stt_expire_list(struct list_head *slot, unsigned long now)
 {
 	int	  expired = 0;
@@ -145,7 +145,7 @@ stt_expire_list(struct list_head *slot, unsigned long now)
 	return expired;
 }
 
-int
+static int
 stt_check_timers(unsigned long *last)
 {
 	int	expired = 0;
@@ -168,7 +168,7 @@ stt_check_timers(unsigned long *last)
 }
 
 
-int
+static int
 stt_timer_main(void *arg)
 {
 	cfs_block_allsigs();
@@ -187,7 +187,7 @@ stt_timer_main(void *arg)
 	return 0;
 }
 
-int
+static int
 stt_start_timer_thread(void)
 {
 	struct task_struct *task;
-- 
1.9.1

