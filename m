Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaHMGyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:54:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:4136 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaHMGys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="371739977"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bhelgaas@google.com, rdunlap@infradead.org
Cc: bp@alien8.de, tony.luck@intel.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RESEND 1/5] RAS, trace: Update error definition format
Date: Wed, 13 Aug 2014 02:22:37 -0400
Message-Id: <1407910961-7798-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous format definition uses MACRO BIT(...), which is not very
maintainable as Bjorn mentioned before:
"I'd like to see all those "BIT(...)" things changed to use the #defines
that already exist in include/uapi/linux/pci_regs.h, e.g.,
PCI_ERR_COR_RCVR.  That way grep will find these uses, which will make
maintenance easier."

Now here it is.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 include/ras/ras_event.h | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 47da53c27ffa..0f2cca4ccbf0 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -8,6 +8,7 @@
 #include <linux/tracepoint.h>
 #include <linux/edac.h>
 #include <linux/ktime.h>
+#include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/cper.h>
 
@@ -174,24 +175,24 @@ TRACE_EVENT(mc_event,
  */
 
 #define aer_correctable_errors		\
-	{BIT(0),	"Receiver Error"},		\
-	{BIT(6),	"Bad TLP"},			\
-	{BIT(7),	"Bad DLLP"},			\
-	{BIT(8),	"RELAY_NUM Rollover"},		\
-	{BIT(12),	"Replay Timer Timeout"},	\
-	{BIT(13),	"Advisory Non-Fatal"}
+	{PCI_ERR_COR_RCVR,	"Receiver Error"},	\
+	{PCI_ERR_COR_BAD_TLP,	"Bad TLP"},		\
+	{PCI_ERR_COR_BAD_DLLP,	"Bad DLLP"},		\
+	{PCI_ERR_COR_REP_ROLL,	"RELAY_NUM Rollover"},	\
+	{PCI_ERR_COR_REP_TIMER,	"Replay Timer Timeout"},\
+	{PCI_ERR_COR_ADV_NFAT,	"Advisory Non-Fatal"}
 
 #define aer_uncorrectable_errors		\
-	{BIT(4),	"Data Link Protocol"},		\
-	{BIT(12),	"Poisoned TLP"},		\
-	{BIT(13),	"Flow Control Protocol"},	\
-	{BIT(14),	"Completion Timeout"},		\
-	{BIT(15),	"Completer Abort"},		\
-	{BIT(16),	"Unexpected Completion"},	\
-	{BIT(17),	"Receiver Overflow"},		\
-	{BIT(18),	"Malformed TLP"},		\
-	{BIT(19),	"ECRC"},			\
-	{BIT(20),	"Unsupported Request"}
+	{PCI_ERR_UNC_DLP,	"Data Link Protocol"},		\
+	{PCI_ERR_UNC_POISON_TLP,"Poisoned TLP"},		\
+	{PCI_ERR_UNC_FCP,	"Flow Control Protocol"},	\
+	{PCI_ERR_UNC_COMP_TIME,	"Completion Timeout"},		\
+	{PCI_ERR_UNC_COMP_ABORT,"Completer Abort"},		\
+	{PCI_ERR_UNC_UNX_COMP,	"Unexpected Completion"},	\
+	{PCI_ERR_UNC_RX_OVER,	"Receiver Overflow"},		\
+	{PCI_ERR_UNC_MALF_TLP,	"Malformed TLP"},		\
+	{PCI_ERR_UNC_ECRC,	"ECRC"},			\
+	{PCI_ERR_UNC_UNSUP,	"Unsupported Request"}
 
 TRACE_EVENT(aer_event,
 	TP_PROTO(const char *dev_name,
-- 
2.0.0.rc2

