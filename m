Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaHMGzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:55:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:45444 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaHMGzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="587404341"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bhelgaas@google.com, rdunlap@infradead.org
Cc: bp@alien8.de, tony.luck@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RESEND 2/5] PCIe, AER: Replenish missed AER status bits for AER driver
Date: Wed, 13 Aug 2014 02:22:38 -0400
Message-Id: <1407910961-7798-3-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 6c2b374d is commited, the capability of PCI-e AER
has changed a lot. This patch adds all missed CE/UC error bits
existed in PCI-e SPEC r3.0. Meanwhile, adjust the code format
to make it simpler to read/maintain.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/pci/pcie/aer/aerdrv_errprint.c | 60 ++++++++++++++--------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 35d06e177917..5c4f7e252e5e 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -75,44 +75,34 @@ static const char *aer_error_layer[] = {
 };
 
 static const char *aer_correctable_error_string[] = {
-	"Receiver Error",		/* Bit Position 0	*/
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	"Bad TLP",			/* Bit Position 6	*/
-	"Bad DLLP",			/* Bit Position 7	*/
-	"RELAY_NUM Rollover",		/* Bit Position 8	*/
-	NULL,
-	NULL,
-	NULL,
-	"Replay Timer Timeout",		/* Bit Position 12	*/
-	"Advisory Non-Fatal",		/* Bit Position 13	*/
+	[0] = "Receiver Error",
+	[6] = "Bad TLP",
+	[7] = "Bad DLLP",
+	[8] = "RELAY_NUM Rollover",
+	[12] = "Replay Timer Timeout",
+	[13] = "Advisory Non-Fatal Error",
+	[14] = "Corrected Internal Error",
+	[15] = "Header Log Overflow",
 };
 
 static const char *aer_uncorrectable_error_string[] = {
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	"Data Link Protocol",		/* Bit Position 4	*/
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	"Poisoned TLP",			/* Bit Position 12	*/
-	"Flow Control Protocol",	/* Bit Position 13	*/
-	"Completion Timeout",		/* Bit Position 14	*/
-	"Completer Abort",		/* Bit Position 15	*/
-	"Unexpected Completion",	/* Bit Position 16	*/
-	"Receiver Overflow",		/* Bit Position 17	*/
-	"Malformed TLP",		/* Bit Position 18	*/
-	"ECRC",				/* Bit Position 19	*/
-	"Unsupported Request",		/* Bit Position 20	*/
+	[0] = "Undefined",
+	[4] = "Data Link Protocol Error",
+	[5] = "Surprise Down Error",
+	[12] = "Poisoned TLP",
+	[13] = "Flow Control Protocol Error",
+	[14] = "Completion Timeout",
+	[15] = "Completer Abort",
+	[16] = "Unexpected Completion",
+	[17] = "Receiver Overflow",
+	[18] = "Malformed TLP",
+	[19] = "ECRC Error",
+	[20] = "Unsupported Request Error",
+	[21] = "ACS Violation",
+	[22] = "Uncorrectable Internal Error",
+	[23] = "MC Blocked TLP",
+	[24] = "AtomicOp Egress Blocked",
+	[25] = "TLP Prefix Blocked Error",
 };
 
 static const char *aer_agent_string[] = {
-- 
2.0.0.rc2

