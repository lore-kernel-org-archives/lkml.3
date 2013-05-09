Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3EITi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:38:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:15805 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab3EITi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:38:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,642,1363158000"; 
   d="scan'208";a="310901318"
From: James Ralston <james.d.ralston@intel.com>
To: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH v2] lpc_ich: Watchdog/GPIO patch for Intel Avoton SoC
Date: Thu,  9 May 2013 12:38:53 -0700
Message-Id: <1368128333-1765-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Controller Device IDs for Watchdog and GPIO for the Intel Avoton SoC.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
Change notes for v2:
*corrected version number

 drivers/mfd/lpc_ich.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 9f12f91..140bf38 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -51,6 +51,7 @@
  *	document number TBD : Lynx Point
  *	document number TBD : Lynx Point-LP
  *	document number TBD : Wellsburg
+ *	document number TBD : Avoton SoC
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -207,6 +208,7 @@ enum lpc_chipsets {
 	LPC_LPT,	/* Lynx Point */
 	LPC_LPT_LP,	/* Lynx Point-LP */
 	LPC_WBG,	/* Wellsburg */
+	LPC_AVN,	/* Avoton SoC */
 };
 
 struct lpc_ich_info lpc_chipset_info[] = {
@@ -491,6 +493,10 @@ struct lpc_ich_info lpc_chipset_info[] = {
 		.name = "Wellsburg",
 		.iTCO_version = 2,
 	},
+	[LPC_AVN] = {
+		.name = "Avoton SoC",
+		.iTCO_version = 1,
+	},
 };
 
 /*
@@ -704,6 +710,10 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_ids) = {
 	{ PCI_VDEVICE(INTEL, 0x8d5d), LPC_WBG},
 	{ PCI_VDEVICE(INTEL, 0x8d5e), LPC_WBG},
 	{ PCI_VDEVICE(INTEL, 0x8d5f), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x1f38), LPC_AVN},
+	{ PCI_VDEVICE(INTEL, 0x1f39), LPC_AVN},
+	{ PCI_VDEVICE(INTEL, 0x1f3a), LPC_AVN},
+	{ PCI_VDEVICE(INTEL, 0x1f3b), LPC_AVN},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
-- 
1.7.7.6

