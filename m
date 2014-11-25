Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaKYN0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:26:31 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63372 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaKYN0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:26:30 -0500
Date: Tue, 25 Nov 2014 13:26:14 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, eunb.song@samsung.com, gulsah.1004@gmail.com,
        paul.gortmaker@windriver.com, devel@driverdev.osuosl.org
Subject: [PATCH] staging: octeon: Fix checkpatch warning
Message-ID: <20141125132614.GA23857@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl warnings:

WARNING: line over 80 characters
+                       int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);

WARNING: line over 80 characters
+                       skb->data = skb->head + work->packet_ptr.s.addr - cvmx_ptr_to_phys(skb->head);

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 drivers/staging/octeon/ethernet-rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 44e372f..bd83f55 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -295,7 +295,8 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			 */
 			union cvmx_pow_wq_int_cntx counts;
 			int backlog;
-			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
+			int cores_in_use = core_state.baseline_cores -
+				atomic_read(&core_state.available_cores);
 			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
 			backlog = counts.s.iq_cnt + counts.s.ds_cnt;
 			if (backlog > budget * cores_in_use && napi != NULL)
@@ -324,7 +325,8 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 		 * buffer.
 		 */
 		if (likely(skb_in_hw)) {
-			skb->data = skb->head + work->packet_ptr.s.addr - cvmx_ptr_to_phys(skb->head);
+			skb->data = skb->head + work->packet_ptr.s.addr -
+				cvmx_ptr_to_phys(skb->head);
 			prefetch(skb->data);
 			skb->len = work->len;
 			skb_set_tail_pointer(skb, skb->len);
-- 
2.1.3

