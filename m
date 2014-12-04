Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaLDNC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:02:27 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:43791 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaLDNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:02:26 -0500
From: Jamie Lawler <jamie.lawler@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: octeon: Add blank lines after declarations
Date: Thu,  4 Dec 2014 13:02:23 +0000
Message-Id: <1417698143-6093-1-git-send-email-jamie.lawler@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 2 missing blank lines after variable declarations in
octeon/ethernet-rx.c. They have been added per the coding style.

Signed-off-by: Jamie Lawler <jamie.lawler@gmail.com>
---
 drivers/staging/octeon/ethernet-rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 1789a12..cecb806 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -109,6 +109,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 		int interface = cvmx_helper_get_interface_num(work->ipprt);
 		int index = cvmx_helper_get_interface_index_num(work->ipprt);
 		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
+
 		gmxx_rxx_frm_ctl.u64 =
 		    cvmx_read_csr(CVMX_GMXX_RXX_FRM_CTL(index, interface));
 		if (gmxx_rxx_frm_ctl.s.pre_chk == 0) {
@@ -212,6 +213,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 		did_work_request = 0;
 		if (work == NULL) {
 			union cvmx_pow_wq_int wq_int;
+
 			wq_int.u64 = 0;
 			wq_int.s.iq_dis = 1 << pow_receive_group;
 			wq_int.s.wq_int = 1 << pow_receive_group;
-- 
2.1.0

