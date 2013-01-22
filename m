Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3AVWHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:07:53 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40918 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3AVWHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:07:50 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH v2 2/4] ima: increase iint flag size
Date: Tue, 22 Jan 2013 17:07:32 -0500
Message-Id: <1358892454-25045-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012222-5806-0000-0000-00001E9CD077
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for hook specific appraise status results, increase
the iint flags size.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 security/integrity/integrity.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 9334691b..329ad26 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -16,19 +16,19 @@
 #include <crypto/sha.h>
 
 /* iint action cache flags */
-#define IMA_MEASURE		0x0001
-#define IMA_MEASURED		0x0002
-#define IMA_APPRAISE		0x0004
-#define IMA_APPRAISED		0x0008
-/*#define IMA_COLLECT		0x0010  do not use this flag */
-#define IMA_COLLECTED		0x0020
-#define IMA_AUDIT		0x0040
-#define IMA_AUDITED		0x0080
+#define IMA_MEASURE		0x00000001
+#define IMA_MEASURED		0x00000002
+#define IMA_APPRAISE		0x00000004
+#define IMA_APPRAISED		0x00000008
+/*#define IMA_COLLECT		0x00000010  do not use this flag */
+#define IMA_COLLECTED		0x00000020
+#define IMA_AUDIT		0x00000040
+#define IMA_AUDITED		0x00000080
 
 /* iint cache flags */
-#define IMA_ACTION_FLAGS	0xff00
-#define IMA_DIGSIG		0x0100
-#define IMA_DIGSIG_REQUIRED	0x0200
+#define IMA_ACTION_FLAGS	0xff000000
+#define IMA_DIGSIG		0x01000000
+#define IMA_DIGSIG_REQUIRED	0x02000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT)
 #define IMA_DONE_MASK		(IMA_MEASURED | IMA_APPRAISED | IMA_AUDITED \
@@ -50,7 +50,7 @@ struct integrity_iint_cache {
 	struct rb_node rb_node; /* rooted in integrity_iint_tree */
 	struct inode *inode;	/* back pointer to inode in question */
 	u64 version;		/* track inode changes */
-	unsigned short flags;
+	unsigned long flags;
 	struct evm_ima_xattr_data ima_xattr;
 	enum integrity_status ima_status:4;
 	enum integrity_status evm_status:4;
-- 
1.8.1.rc3

