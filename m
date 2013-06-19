Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414Ab3FTABI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:01:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:30052 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934604Ab3FTABG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,900,1363158000"; 
   d="scan'208";a="356460889"
From: Seth Heasley <seth.heasley@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH 3/4] i2c-i801: SMBus patch for Intel Coleto Creek DeviceIDs
Date: Wed, 19 Jun 2013 16:59:57 -0700
Message-Id: <1371686397-6532-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the i801 SMBus Controller DeviceIDs for the Intel Coleto Creek PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index d55b8ab..d29dea0 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -24,6 +24,7 @@ Supported adapters:
   * Intel Lynx Point-LP (PCH)
   * Intel Avoton (SOC)
   * Intel Wellsburg (PCH)
+  * Intel Coleto Creek (PCH)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 631736e..da3af83 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -108,6 +108,7 @@ config I2C_I801
 	    Lynx Point-LP (PCH)
 	    Avoton (SOC)
 	    Wellsburg (PCH)
+	    Coleto Creek (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 3a6903f..4ebceed 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -58,6 +58,7 @@
   Wellsburg (PCH) MS    0x8d7d     32     hard     yes     yes     yes
   Wellsburg (PCH) MS    0x8d7e     32     hard     yes     yes     yes
   Wellsburg (PCH) MS    0x8d7f     32     hard     yes     yes     yes
+  Coleto Creek (PCH)    0x23b0     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -169,6 +170,7 @@
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
 #define PCI_DEVICE_ID_INTEL_AVOTON_SMBUS	0x1f3c
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
+#define PCI_DEVICE_ID_INTEL_COLETOCREEK_SMBUS	0x23b0
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
 #define PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS	0x8d22
@@ -817,6 +819,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COLETOCREEK_SMBUS) },
 	{ 0, }
 };
 
-- 
1.7.4.4

