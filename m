Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075Ab3DKUkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:40:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3DKUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:57 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Y9a_abLJiAEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tMW0dAI80dEA:10 a=20KFwNOVAAAA:8 a=Q-fNiiVtAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jEp0ucaQiEUA:10 a=lcTMV_K9oDIA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202548.902180930@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michal Schmidt <mschmidt@redhat.com>, Dmitry Kravkov <dmitry@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 016/171 ] bnx2x: add missing napi deletion in error path
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0016-bnx2x-add-missing-napi-deletion-in-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 722c6f585088a2c392b4c5d01b87a584bb8fb73f ]

If the hardware initialization fails in bnx2x_nic_load() after adding
napi objects, they would not be deleted. A subsequent attempt to unload
the bnx2x module detects a corruption in the napi list.

Add the missing napi deletion to the error path.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e8e97a7..cb18cf4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2323,6 +2323,7 @@ load_error2:
 	bp->port.pmf = 0;
 load_error1:
 	bnx2x_napi_disable(bp);
+	bnx2x_del_all_napi(bp);
 	/* clear pf_load status, as it was already set */
 	bnx2x_clear_pf_load(bp);
 load_error0:
-- 
1.7.10.4


