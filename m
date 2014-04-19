Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaDSVU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 17:20:27 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44130 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaDSVUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 17:20:00 -0400
From: Dimitri John Ledkov <dimitri.ledkov@surgut.co.uk>
To: linux-nvme@lists.infradead.org
Cc: keith.busch@intel.com, willy@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] NVMe: Update namespace and controller identity structures as per 1.1a spec
Date: Sat, 19 Apr 2014 22:19:57 +0100
Message-Id: <1397942397-29998-1-git-send-email-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Controller: add CNTLID, AVSCC, APSTA, NVSCC, ACWU, SGLS fields.

Namespace: add NMIC, RESCAP, EUI64 fields. EUI64 is specifically
interesting, since it can be used to construct an UEFI NVMe device
path for a boot entry.

As per NVM Express 1.1a spec:
http://www.nvmexpress.org/wp-content/uploads/NVM-Express-1_1a.pdf

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 include/uapi/linux/nvme.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nvme.h b/include/uapi/linux/nvme.h
index 096fe1c..73cb2af 100644
--- a/include/uapi/linux/nvme.h
+++ b/include/uapi/linux/nvme.h
@@ -49,7 +49,8 @@ struct nvme_id_ctrl {
 	__u8			ieee[3];
 	__u8			mic;
 	__u8			mdts;
-	__u8			rsvd78[178];
+	__le16			cntlid;
+	__u8			rsvd80[176];
 	__le16			oacs;
 	__u8			acl;
 	__u8			aerl;
@@ -57,7 +58,9 @@ struct nvme_id_ctrl {
 	__u8			lpa;
 	__u8			elpe;
 	__u8			npss;
-	__u8			rsvd264[248];
+	__u8			avscc;
+	__u8			apsta;
+	__u8			rsvd266[246];
 	__u8			sqes;
 	__u8			cqes;
 	__u8			rsvd514[2];
@@ -68,7 +71,12 @@ struct nvme_id_ctrl {
 	__u8			vwc;
 	__le16			awun;
 	__le16			awupf;
-	__u8			rsvd530[1518];
+	__u8			nvscc;
+	__u8			rsvd531;
+	__le16			acwu;
+	__u8			rsvd534[2];
+	__le32			sgls;
+	__u8			rsvd540[1508];
 	struct nvme_id_power_state	psd[32];
 	__u8			vs[1024];
 };
@@ -95,7 +103,10 @@ struct nvme_id_ns {
 	__u8			mc;
 	__u8			dpc;
 	__u8			dps;
-	__u8			rsvd30[98];
+	__u8			nmic;
+	__u8			rescap;
+	__u8			rsvd32[88];
+	__le64			eui64;
 	struct nvme_lbaf	lbaf[16];
 	__u8			rsvd192[192];
 	__u8			vs[3712];
-- 
1.9.1

