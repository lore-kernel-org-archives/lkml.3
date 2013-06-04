Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3FDXHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:07:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35566 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3FDWmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:47 -0400
Message-Id: <20130604172133.581928344@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Boaz Harrosh <bharrosh@panasas.com>,
        James Smart <james.smart@emulex.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Bork <tom@eisfair.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 079/184] scsi: use __uX types for headers exported to user
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 space

From: Peter Korsgaard <jacmet@sunsite.dk>

Commit 9e4f5e29 ("FC Pass Thru support") exported a number of header files
in include/scsi to user space, but didn't change the uX types to the
userspace-compatible __uX types.  Without that you'll get compile errors
when including them - E.G.:

include/scsi/scsi.h:145: error: expected specifier-qualifier-list before `u8'

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 083c8c1e60e5c27a277e87dbeb6b89b47937559f)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/scsi/scsi.h         | 8 ++++----
 include/scsi/scsi_netlink.h | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 34c46ab..b3cffec 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -145,10 +145,10 @@ struct scsi_cmnd;
 
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 536752c..58ce8fe 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -105,8 +105,8 @@ struct scsi_nl_host_vendor_msg {
  *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
  */
 #define SCSI_NL_VID_TYPE_SHIFT		56
-#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
-#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_MASK		((__u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_PCI		((__u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
 #define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
 
 
-- 
1.7.12.2.21.g234cd45.dirty



