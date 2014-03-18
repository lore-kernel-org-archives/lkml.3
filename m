Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbaCRU6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:58:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:13521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824AbaCRUxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172336"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 02/13] mei: me: introduce power gating registers
Date: Tue, 18 Mar 2014 22:51:56 +0200
Message-Id: <1395175927-10562-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LPT devices have internal power gating handled
through registers and hbm calls

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 66f411a..72ba4d5 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -128,6 +128,8 @@
 #define ME_CB_RW   8
 /* ME_CSR_HA - ME Control Status Host Access register (read only) */
 #define ME_CSR_HA  0xC
+/* H_HGC_CSR - PGI register */
+#define H_HPG_CSR  0x10
 
 
 /* register bits of H_CSR (Host Control Status register) */
@@ -157,6 +159,8 @@ access to ME_CBD */
 #define ME_CBWP_HRA       0x00FF0000
 /* ME CB Read Pointer HRA - host read only access to ME_CBRP */
 #define ME_CBRP_HRA       0x0000FF00
+/* ME Power Gate Isolation Capability HRA  - host ready only access */
+#define ME_PGIC_HRA       0x00000040
 /* ME Reset HRA - host read only access to ME_RST */
 #define ME_RST_HRA        0x00000010
 /* ME Ready HRA - host read only access to ME_RDY */
@@ -168,4 +172,9 @@ access to ME_CBD */
 /* ME Interrupt Enable HRA - host read only access to ME_IE */
 #define ME_IE_HRA         0x00000001
 
+
+/* register bits - H_HPG_CSR */
+#define H_HPG_CSR_PGIHEXR       0x00000001
+#define H_HPG_CSR_PGI           0x00000002
+
 #endif /* _MEI_HW_MEI_REGS_H_ */
-- 
1.8.5.3

