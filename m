Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaJ0TQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:16:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaJ0TDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arun Easi <arun.easi@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Christoph Hellwig <hch@lst.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 049/105] qla2xxx: Use correct offset to req-q-out for reserve calculation
Date: Mon, 27 Oct 2014 11:56:24 -0700
Message-Id: <1414436240-13879-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Easi <arun.easi@qlogic.com>

commit 75554b68ac1e018bca00d68a430b92ada8ab52dd upstream.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 358c176..33682a5 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1361,12 +1361,10 @@ static inline void qlt_unmap_sg(struct scsi_qla_host *vha,
 static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
 	uint32_t req_cnt)
 {
-	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg = ha->iobase;
 	uint32_t cnt;
 
 	if (vha->req->cnt < (req_cnt + 2)) {
-		cnt = (uint16_t)RD_REG_DWORD(&reg->isp24.req_q_out);
+		cnt = (uint16_t)RD_REG_DWORD(vha->req->req_q_out);
 
 		ql_dbg(ql_dbg_tgt, vha, 0xe00a,
 		    "Request ring circled: cnt=%d, vha->->ring_index=%d, "
-- 
1.9.1

