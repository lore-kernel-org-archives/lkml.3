Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaBKTYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:24:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaBKTIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Chan, Wei Sern" <wei.sern.chan@intel.com>
Subject: [PATCH 3.10 65/79] mfd: lpc_ich: Add support for Intel Avoton SoC
Date: Tue, 11 Feb 2014 11:06:09 -0800
Message-Id: <20140211184722.855229027@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 8477128fe0c3c455e9dfb1ba7ad7e6d09489d33c upstream.

This patch adds the LPC Controller Device IDs for Watchdog and GPIO for
Intel Avoton SoC, to the lpc_ich driver.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: "Chan, Wei Sern" <wei.sern.chan@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/lpc_ich.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

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
@@ -491,6 +493,10 @@ struct lpc_ich_info lpc_chipset_info[] =
 		.name = "Wellsburg",
 		.iTCO_version = 2,
 	},
+	[LPC_AVN] = {
+		.name = "Avoton SoC",
+		.iTCO_version = 1,
+	},
 };
 
 /*
@@ -704,6 +710,10 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_i
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


