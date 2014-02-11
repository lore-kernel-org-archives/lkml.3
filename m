Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaBKTYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:24:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaBKTIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Chan, Wei Sern" <wei.sern.chan@intel.com>
Subject: [PATCH 3.10 66/79] mfd: lpc_ich: iTCO_wdt patch for Intel Coleto Creek DeviceIDs
Date: Tue, 11 Feb 2014 11:06:10 -0800
Message-Id: <20140211184722.883100499@linuxfoundation.org>
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

From: Seth Heasley <seth.heasley@intel.com>

commit 283aae8ab88e695a660c610d6535ca44bc5b8835 upstream.

This patch adds the LPC Controller DeviceIDs for iTCO Watchdog for
the Intel Coleto Creek PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: "Chan, Wei Sern" <wei.sern.chan@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/lpc_ich.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -52,6 +52,7 @@
  *	document number TBD : Lynx Point-LP
  *	document number TBD : Wellsburg
  *	document number TBD : Avoton SoC
+ *	document number TBD : Coleto Creek
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -209,6 +210,7 @@ enum lpc_chipsets {
 	LPC_LPT_LP,	/* Lynx Point-LP */
 	LPC_WBG,	/* Wellsburg */
 	LPC_AVN,	/* Avoton SoC */
+	LPC_COLETO,	/* Coleto Creek */
 };
 
 struct lpc_ich_info lpc_chipset_info[] = {
@@ -497,6 +499,10 @@ struct lpc_ich_info lpc_chipset_info[] =
 		.name = "Avoton SoC",
 		.iTCO_version = 1,
 	},
+	[LPC_COLETO] = {
+		.name = "Coleto Creek",
+		.iTCO_version = 2,
+	},
 };
 
 /*
@@ -714,6 +720,7 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_i
 	{ PCI_VDEVICE(INTEL, 0x1f39), LPC_AVN},
 	{ PCI_VDEVICE(INTEL, 0x1f3a), LPC_AVN},
 	{ PCI_VDEVICE(INTEL, 0x1f3b), LPC_AVN},
+	{ PCI_VDEVICE(INTEL, 0x2390), LPC_COLETO},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);


