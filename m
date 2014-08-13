Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaHMG43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:56:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:45629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbaHMG41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:56:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="557844784"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bhelgaas@google.com, rdunlap@infradead.org
Cc: bp@alien8.de, tony.luck@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RESEND 3/5] PCIe, trace: Replenish missed AER status bits for PCIE trace I/F
Date: Wed, 13 Aug 2014 02:22:39 -0400
Message-Id: <1407910961-7798-4-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds all missed AER error bits(CE & UC) existed in PCI-e
SPEC r3.0 for trace interface.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 include/ras/ras_event.h | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 0f2cca4ccbf0..0f04a9755d1e 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -174,25 +174,34 @@ TRACE_EVENT(mc_event,
  * u8 severity -	error severity 0:NONFATAL 1:FATAL 2:CORRECTED
  */
 
-#define aer_correctable_errors		\
-	{PCI_ERR_COR_RCVR,	"Receiver Error"},	\
-	{PCI_ERR_COR_BAD_TLP,	"Bad TLP"},		\
-	{PCI_ERR_COR_BAD_DLLP,	"Bad DLLP"},		\
-	{PCI_ERR_COR_REP_ROLL,	"RELAY_NUM Rollover"},	\
-	{PCI_ERR_COR_REP_TIMER,	"Replay Timer Timeout"},\
-	{PCI_ERR_COR_ADV_NFAT,	"Advisory Non-Fatal"}
-
-#define aer_uncorrectable_errors		\
-	{PCI_ERR_UNC_DLP,	"Data Link Protocol"},		\
+#define aer_correctable_errors					\
+	{PCI_ERR_COR_RCVR,	"Receiver Error"},		\
+	{PCI_ERR_COR_BAD_TLP,	"Bad TLP"},			\
+	{PCI_ERR_COR_BAD_DLLP,	"Bad DLLP"},			\
+	{PCI_ERR_COR_REP_ROLL,	"RELAY_NUM Rollover"},		\
+	{PCI_ERR_COR_REP_TIMER,	"Replay Timer Timeout"},	\
+	{PCI_ERR_COR_ADV_NFAT,	"Advisory Non-Fatal Error"},	\
+	{PCI_ERR_COR_INTERNAL,	"Corrected Internal Error"},	\
+	{PCI_ERR_COR_LOG_OVER,	"Header Log Overflow"}
+
+#define aer_uncorrectable_errors				\
+	{PCI_ERR_UNC_TRAIN,	"Undefined"},			\
+	{PCI_ERR_UNC_DLP,	"Data Link Protocol Error"},	\
+	{PCI_ERR_UNC_SURPDN,	"Surprise Down Error"},		\
 	{PCI_ERR_UNC_POISON_TLP,"Poisoned TLP"},		\
-	{PCI_ERR_UNC_FCP,	"Flow Control Protocol"},	\
+	{PCI_ERR_UNC_FCP,	"Flow Control Protocol Error"},	\
 	{PCI_ERR_UNC_COMP_TIME,	"Completion Timeout"},		\
 	{PCI_ERR_UNC_COMP_ABORT,"Completer Abort"},		\
 	{PCI_ERR_UNC_UNX_COMP,	"Unexpected Completion"},	\
 	{PCI_ERR_UNC_RX_OVER,	"Receiver Overflow"},		\
 	{PCI_ERR_UNC_MALF_TLP,	"Malformed TLP"},		\
-	{PCI_ERR_UNC_ECRC,	"ECRC"},			\
-	{PCI_ERR_UNC_UNSUP,	"Unsupported Request"}
+	{PCI_ERR_UNC_ECRC,	"ECRC Error"},			\
+	{PCI_ERR_UNC_UNSUP,	"Unsupported Request Error"},	\
+	{PCI_ERR_UNC_ACSV,	"ACS Violation"},		\
+	{PCI_ERR_UNC_INTN,	"Uncorrectable Internal Error"},\
+	{PCI_ERR_UNC_MCBTLP,	"MC Blocked TLP"},		\
+	{PCI_ERR_UNC_ATOMEG,	"AtomicOp Egress Blocked"},	\
+	{PCI_ERR_UNC_TLPPRE,	"TLP Prefix Blocked Error"}
 
 TRACE_EVENT(aer_event,
 	TP_PROTO(const char *dev_name,
-- 
2.0.0.rc2

