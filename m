Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935434Ab3FTAF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:05:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:34058 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FTAF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:05:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,900,1363158000"; 
   d="scan'208";a="332437458"
From: Seth Heasley <seth.heasley@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org
Cc: James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH 4/4] lpc_ich: iTCO_wdt patch for Intel Coleto Creek DeviceIDs
Date: Wed, 19 Jun 2013 17:04:25 -0700
Message-Id: <1371686665-6622-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Controller DeviceIDs for iTCO Watchdog for the Intel Coleto Creek PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 drivers/mfd/lpc_ich.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 9f12f91..b9df8db 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -51,6 +51,7 @@
  *	document number TBD : Lynx Point
  *	document number TBD : Lynx Point-LP
  *	document number TBD : Wellsburg
+ *	document number TBD : Coleto Creek
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -207,6 +208,7 @@ enum lpc_chipsets {
 	LPC_LPT,	/* Lynx Point */
 	LPC_LPT_LP,	/* Lynx Point-LP */
 	LPC_WBG,	/* Wellsburg */
+	LPC_COLETO,	/* Coleto Creek */
 };
 
 struct lpc_ich_info lpc_chipset_info[] = {
@@ -491,6 +493,10 @@ struct lpc_ich_info lpc_chipset_info[] = {
 		.name = "Wellsburg",
 		.iTCO_version = 2,
 	},
+	[LPC_COLETO] = {
+		.name = "Coleto Creek",
+		.iTCO_version = 2,
+	},
 };
 
 /*
@@ -704,6 +710,7 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_ids) = {
 	{ PCI_VDEVICE(INTEL, 0x8d5d), LPC_WBG},
 	{ PCI_VDEVICE(INTEL, 0x8d5e), LPC_WBG},
 	{ PCI_VDEVICE(INTEL, 0x8d5f), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x2390), LPC_COLETO},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
-- 
1.7.4.4

