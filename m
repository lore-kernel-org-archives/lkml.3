Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3AYTM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:12:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:52143 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab3AYTM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:12:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,540,1355126400"; 
   d="scan'208";a="276705708"
From: Seth Heasley <seth.heasley@intel.com>
To: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH 3/3] i2c-i801: SMBus patch for Intel Avoton DeviceIDs
Date: Fri, 25 Jan 2013 12:11:01 -0800
Message-Id: <1359144661-3528-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the PCU SMBus DeviceID for the Intel Avoton SOC.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index 157416e..8d71d57 100644
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
index 0bb7ff4..87df863 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -106,6 +106,7 @@ config I2C_I801
 	    Panther Point (PCH)
 	    Lynx Point (PCH)
 	    Lynx Point-LP (PCH)
+	    Avoton (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 3092387..af15aeb 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -53,6 +53,7 @@
   Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
   Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
   Lynx Point-LP (PCH)   0x9c22     32     hard     yes     yes     yes
+  Avoton (SOC)          0x1f3c     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -166,6 +167,7 @@
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
+#define PCI_DEVICE_ID_INTEL_AVOTON_SMBUS	0x1f3c
 
 struct i801_mux_config {
 	char *gpio_chip;
@@ -798,6 +800,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_AVOTON_SMBUS) },
 	{ 0, }
 };
 
-- 
1.7.4.4

