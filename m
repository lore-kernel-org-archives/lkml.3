Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaAICWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 21:22:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28846 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaAICWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 21:22:34 -0500
From: Vaughan Cao <vaughan.cao@oracle.com>
To: michaelc@cs.wisc.edu
Cc: JBottomley@parallels.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaughan.cao@oracle.com
Subject: [PATCH] iscsi: fix wrong order of opcode and itt in iscsi_handle_reject prompt
Date: Thu,  9 Jan 2014 10:21:34 +0800
Message-Id: <1389234094-6134-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes reject messages show right value for opcode and itt, which
is converse previously.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/libiscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..27547ff 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1013,13 +1013,13 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected "
 				  "due to DataDigest error.\n",
-				  rejected_pdu.itt, opcode);
+				  opcode, rejected_pdu.itt);
 		break;
 	case ISCSI_REASON_IMM_CMD_REJECT:
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected. Too many "
 				  "immediate commands.\n",
-				  rejected_pdu.itt, opcode);
+				  opcode, rejected_pdu.itt);
 		/*
 		 * We only send one TMF at a time so if the target could not
 		 * handle it, then it should get fixed (RFC mandates that
@@ -1059,8 +1059,8 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	default:
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "pdu (op 0x%x itt 0x%x) rejected. Reason "
-				  "code 0x%x\n", rejected_pdu.itt,
-				  rejected_pdu.opcode, reject->reason);
+				  "code 0x%x\n", rejected_pdu.opcode,
+				  rejected_pdu.itt, reject->reason);
 		break;
 	}
 	return rc;
-- 
1.8.3.1

