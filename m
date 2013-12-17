Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3LQSa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:30:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3LQSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seth Heasley <seth.heasley@intel.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 056/103] i2c: i801: SMBus patch for Intel Avoton DeviceIDs
Date: Tue, 17 Dec 2013 18:12:45 +0000
Message-Id: <1387304012-23805-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit c2db409cbc8751ccc7e6d2cc2e41af0d12ea637f upstream.

This patch adds the PCU SMBus DeviceID for the Intel Avoton SOC.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/i2c/busses/i2c-i801 | 1 +
 drivers/i2c/busses/Kconfig        | 1 +
 drivers/i2c/busses/i2c-i801.c     | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index 99d4e44..8bb57d7 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -22,6 +22,7 @@ Supported adapters:
   * Intel Panther Point (PCH)
   * Intel Lynx Point (PCH)
   * Intel Lynx Point-LP (PCH)
+  * Intel Avoton (SOC)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index f2f2058..d63973d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -105,6 +105,7 @@ config I2C_I801
 	    Panther Point (PCH)
 	    Lynx Point (PCH)
 	    Lynx Point-LP (PCH)
+	    Avoton (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index d88ec81..d63e130 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -53,6 +53,7 @@
   Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
   Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
   Lynx Point-LP (PCH)   0x9c22     32     hard     yes     yes     yes
+  Avoton (SOC)          0x1f3c     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -145,6 +146,7 @@
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF1	0x1d71
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF2	0x1d72
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
+#define PCI_DEVICE_ID_INTEL_AVOTON_SMBUS	0x1f3c
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
@@ -639,6 +641,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_AVOTON_SMBUS) },
 	{ 0, }
 };
 
-- 
1.8.3.2

