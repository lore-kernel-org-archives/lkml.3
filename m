Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaKZM2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:28:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaKZM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:28:38 -0500
From: Athira Lekshmi C V <andnlnbn18@gmail.com>
To: gregkh@linuxfoundation.org
Cc: paul.gortmaker@windriver.com, gulsah.1004@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Athira Lekshmi C V <andnlnbn18@gmail.com>
Subject: [PATCH] Drivers:staging:octeon: Fixed checkpatch warning
Date: Wed, 26 Nov 2014 17:58:37 +0530
Message-Id: <1417004917-1398-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning:
WARNING: Missing a blank line after declarations

Signed-off-by: Athira Lekshmi C V <andnlnbn18@gmail.com>
---
 drivers/staging/octeon/ethernet-rx.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 44e372f..a7ff01c 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -84,6 +84,7 @@ static int cvm_irq_cpu;
 static void cvm_oct_enable_napi(void *_)
 {
 	int cpu = smp_processor_id();
+
 	napi_schedule(&cvm_oct_napi[cpu].napi);
 }
 
@@ -296,6 +297,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			union cvmx_pow_wq_int_cntx counts;
 			int backlog;
 			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
+
 			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
 			backlog = counts.s.iq_cnt + counts.s.ds_cnt;
 			if (backlog > budget * cores_in_use && napi != NULL)
-- 
1.7.9.5

