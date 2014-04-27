Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaD0RHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:07:49 -0400
Received: from linuxhacker.ru ([217.76.32.60]:47983 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbaD0RHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:47 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 10/47] staging/lustre/gss: fix few issues found by Klocwork Insight tool
Date: Sun, 27 Apr 2014 13:06:34 -0400
Message-Id: <1398618431-29757-11-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Array 'message_buf' of size 500 may use index value(s) -1

Object 'enc_key.data' was freed at line 164 after being freed
by calling 'free' at line 150. Also there are 3 similar errors
on line(s) 164.

Suspicious dereference of pointer 'vmsg' before NULL check at
line 187. Also there are 2 similar errors on line(s) 196, 205.

Suspicious dereference of pointer 'rmsg' before NULL check at
line 191. Also there are 2 similar errors on line(s) 200, 209.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9274
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
index 7852bf3..93794bd 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
@@ -176,31 +176,31 @@ int gss_cli_ctx_unwrap_bulk(struct ptlrpc_cli_ctx *ctx,
 	switch (SPTLRPC_FLVR_SVC(req->rq_flvr.sf_rpc)) {
 	case SPTLRPC_SVC_NULL:
 		vmsg = req->rq_repdata;
+		LASSERT(vmsg != NULL && vmsg->lm_bufcount >= 3);
 		voff = vmsg->lm_bufcount - 1;
-		LASSERT(vmsg && vmsg->lm_bufcount >= 3);
 
 		rmsg = req->rq_reqbuf;
+		LASSERT(rmsg != NULL && rmsg->lm_bufcount >= 3);
 		roff = rmsg->lm_bufcount - 1; /* last segment */
-		LASSERT(rmsg && rmsg->lm_bufcount >= 3);
 		break;
 	case SPTLRPC_SVC_AUTH:
 	case SPTLRPC_SVC_INTG:
 		vmsg = req->rq_repdata;
+		LASSERT(vmsg != NULL && vmsg->lm_bufcount >= 4);
 		voff = vmsg->lm_bufcount - 2;
-		LASSERT(vmsg && vmsg->lm_bufcount >= 4);
 
 		rmsg = req->rq_reqbuf;
+		LASSERT(rmsg != NULL && rmsg->lm_bufcount >= 4);
 		roff = rmsg->lm_bufcount - 2; /* second last segment */
-		LASSERT(rmsg && rmsg->lm_bufcount >= 4);
 		break;
 	case SPTLRPC_SVC_PRIV:
 		vmsg = req->rq_repdata;
+		LASSERT(vmsg != NULL && vmsg->lm_bufcount >= 2);
 		voff = vmsg->lm_bufcount - 1;
-		LASSERT(vmsg && vmsg->lm_bufcount >= 2);
 
 		rmsg = req->rq_clrbuf;
+		LASSERT(rmsg != NULL && rmsg->lm_bufcount >= 2);
 		roff = rmsg->lm_bufcount - 1; /* last segment */
-		LASSERT(rmsg && rmsg->lm_bufcount >= 2);
 		break;
 	default:
 		LBUG();
-- 
1.8.5.3

