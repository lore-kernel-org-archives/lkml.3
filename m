Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129Ab3HHS3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:29:55 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39689 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966109Ab3HHS3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:29:53 -0400
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        m.chehab@samsung.com
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: [PATCH 1/3] mce: acpi/apei: trace: Include PCIe AER trace event conditionally
Date: Thu,  8 Aug 2013 23:57:49 +0530
Message-Id: <1375986471-27113-2-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080818-0260-0000-0000-000003710CE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we'll be adding multiple trace events to ras.h, we need to protect
each block appropriately so that they only get included in the right
places. Update PCIe AER trace event for this purpose.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 drivers/pci/pcie/aer/aerdrv_errprint.c | 1 +
 include/trace/events/ras.h             | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 2c7c9f5..4d06859 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -24,6 +24,7 @@
 #include "aerdrv.h"
 
 #define CREATE_TRACE_POINTS
+#define TRACE_EVENT_PCIE_AER
 #include <trace/events/ras.h>
 
 #define AER_AGENT_RECEIVER		0
diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
index 88b8783..4a66142 100644
--- a/include/trace/events/ras.h
+++ b/include/trace/events/ras.h
@@ -1,7 +1,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM ras
 
-#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
+#if (!defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)) && defined(TRACE_EVENT_PCIE_AER)
 #define _TRACE_AER_H
 
 #include <linux/tracepoint.h>
-- 
1.8.3.4

