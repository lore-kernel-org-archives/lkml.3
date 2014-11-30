Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaK3Q00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:26:26 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49471 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaK3Q0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:26:25 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org, paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH] drivers:staging:octeon:ethernet-rx.c: Added blank line after declarations
Date: Sun, 30 Nov 2014 21:55:29 +0530
Message-Id: <1417364729-5279-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl warnings:

WARNING: Missing blank line after declaration

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/octeon/ethernet-rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 44e372f..61131ff 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -84,6 +84,7 @@ static int cvm_irq_cpu;
 static void cvm_oct_enable_napi(void *_)
 {
 	int cpu = smp_processor_id();
+
 	napi_schedule(&cvm_oct_napi[cpu].napi);
 }
 
@@ -169,6 +170,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 		int interface = cvmx_helper_get_interface_num(work->ipprt);
 		int index = cvmx_helper_get_interface_index_num(work->ipprt);
 		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
+
 		gmxx_rxx_frm_ctl.u64 =
 		    cvmx_read_csr(CVMX_GMXX_RXX_FRM_CTL(index, interface));
 		if (gmxx_rxx_frm_ctl.s.pre_chk == 0) {
@@ -272,6 +274,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 		did_work_request = 0;
 		if (work == NULL) {
 			union cvmx_pow_wq_int wq_int;
+
 			wq_int.u64 = 0;
 			wq_int.s.iq_dis = 1 << pow_receive_group;
 			wq_int.s.wq_int = 1 << pow_receive_group;
@@ -296,6 +299,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			union cvmx_pow_wq_int_cntx counts;
 			int backlog;
 			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
+
 			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
 			backlog = counts.s.iq_cnt + counts.s.ds_cnt;
 			if (backlog > budget * cores_in_use && napi != NULL)
-- 
1.9.1

