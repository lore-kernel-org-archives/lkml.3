Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab3AOS5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:57:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:34779 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919Ab3AOS5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:57:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steve Hodgson <steve@purestorage.com>,
        Armen Baloyan <armen.baloyan@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 036/221] SCSI: qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()
Date: Tue, 15 Jan 2013 10:49:23 -0800
Message-Id: <20130115185000.636435563@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Hodgson <steve@purestorage.com>

commit 9bceab4e08c5e329e9def7fe1cab41c467236517 upstream.

Signed-off-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_bsg.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -743,7 +743,7 @@ qla2x00_process_loopback(struct fc_bsg_j
 				ql_log(ql_log_warn, vha, 0x701f,
 				    "Get port config failed.\n");
 				rval = -EPERM;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 
 			ql_dbg(ql_dbg_user, vha, 0x70c0,
@@ -762,7 +762,7 @@ qla2x00_process_loopback(struct fc_bsg_j
 
 			if (rval) {
 				rval = -EPERM;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
@@ -795,7 +795,7 @@ qla2x00_process_loopback(struct fc_bsg_j
 				}
 
 				rval = -EIO;
-				goto done_free_dma_req;
+				goto done_free_dma_rsp;
 			}
 		} else {
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
@@ -830,6 +830,7 @@ qla2x00_process_loopback(struct fc_bsg_j
 	fw_sts_ptr += sizeof(response);
 	*fw_sts_ptr = command_sent;
 
+done_free_dma_rsp:
 	dma_free_coherent(&ha->pdev->dev, rsp_data_len,
 		rsp_data, rsp_data_dma);
 done_free_dma_req:


