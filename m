Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216Ab3FTJY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:24:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:12721 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965024Ab3FTJY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:24:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="332633975"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH] x86/MCE: Update MCE severity condition check
Date: Thu, 20 Jun 2013 05:16:12 -0400
Message-Id: <1371719773-27572-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update some SRAR severity conditions check to make it clearer,
according to latest Intel SDM Vol 3(June 2013), table 15-20.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index beb1f16..1fa12ea 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -110,22 +110,17 @@ static struct severity {
 	/* known AR MCACODs: */
 #ifdef	CONFIG_MEMORY_FAILURE
 	MCESEV(
-		KEEP, "HT thread notices Action required: data load error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
-		MCGMASK(MCG_STATUS_EIPV, 0)
+		KEEP, "Action required but non-affected thread is continuable",
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
+		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
 		),
 	MCESEV(
-		AR, "Action required: data load error",
+		AR, "Action required: data load error on user land",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		USER
 		),
 	MCESEV(
-		KEEP, "HT thread notices Action required: instruction fetch error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
-		MCGMASK(MCG_STATUS_EIPV, 0)
-		),
-	MCESEV(
-		AR, "Action required: instruction fetch error",
+		AR, "Action required: instruction fetch error on user land",
 		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
 		USER
 		),
-- 
1.7.10.4

