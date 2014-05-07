Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaEGT4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:56:03 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42829 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaEGTz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:55:57 -0400
From: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Subject: [PATCH v2] NVMe: Update namespace and controller identity structures as per 1.1a spec
Date: Wed,  7 May 2014 20:55:30 +0100
Message-Id: <1399492530-7774-1-git-send-email-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <20140423151304.GF13050@linux.intel.com>
References: <20140423151304.GF13050@linux.intel.com>
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

 Changes since v1:
  - Change cntlid from __le16 to __u16 ("it's a cookie")
  - Change eui64 from __le64 to __u8[8] (as per IEEE's recommendation)

 include/uapi/linux/nvme.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/nvme.h b/include/uapi/linux/nvme.h
index f090336..e74da78 100644
--- a/include/uapi/linux/nvme.h
+++ b/include/uapi/linux/nvme.h
@@ -45,7 +45,8 @@ struct nvme_id_ctrl {
 	__u8			ieee[3];
 	__u8			mic;
 	__u8			mdts;
-	__u8			rsvd78[178];
+	__u16			cntlid;
+	__u8			rsvd80[176];
 	__le16			oacs;
 	__u8			acl;
 	__u8			aerl;
@@ -53,7 +54,9 @@ struct nvme_id_ctrl {
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
@@ -64,7 +67,12 @@ struct nvme_id_ctrl {
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
@@ -92,7 +100,10 @@ struct nvme_id_ns {
 	__u8			mc;
 	__u8			dpc;
 	__u8			dps;
-	__u8			rsvd30[98];
+	__u8			nmic;
+	__u8			rescap;
+	__u8			rsvd32[88];
+	__u8			eui64[8];
 	struct nvme_lbaf	lbaf[16];
 	__u8			rsvd192[192];
 	__u8			vs[3712];
-- 
2.0.0.rc0

