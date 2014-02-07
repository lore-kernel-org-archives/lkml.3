Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaBGQ1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:27:18 -0500
Received: from palahniuk.acksyn.org ([5.9.7.26]:54345 "EHLO
	palahniuk.acksyn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaBGQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:27:12 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Feb 2014 11:27:12 EST
From: Michele Baldessari <michele@acksyn.org>
To: open-iscsi@googlegroups.com
Cc: trivial@kernel.org, chorn@redhat.com, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>,
        Michele Baldessari <michele@acksyn.org>
Subject: [PATCH] Fix the arguments order of a few iscsi_conn_printk() calls
Date: Fri,  7 Feb 2014 16:18:53 +0000
Message-Id: <1391789933-15062-1-git-send-email-michele@acksyn.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few places had the opcode and itt arguments reversed.
Fix the order.

Reported-by: Josef Moellers <josef.moellers@ts.fujitsu.com>
Signed-off-by: Michele Baldessari <michele@acksyn.org>
---
 drivers/scsi/libiscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4046241..cd330c0 100644
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
1.8.5.3

