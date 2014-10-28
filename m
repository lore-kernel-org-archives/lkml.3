Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbaJ1Ht7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:49:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaJ1Dib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:38:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arun Easi <arun.easi@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.17 037/146] qla2xxx: Use correct offset to req-q-out for reserve calculation
Date: Tue, 28 Oct 2014 11:32:59 +0800
Message-Id: <20141028033345.030973148@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Easi <arun.easi@qlogic.com>

commit 75554b68ac1e018bca00d68a430b92ada8ab52dd upstream.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_target.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1431,12 +1431,10 @@ static inline void qlt_unmap_sg(struct s
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


