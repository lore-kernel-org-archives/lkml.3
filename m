Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaB1IBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:01:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:40115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaB1IBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:01:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,560,1389772800"; 
   d="scan'208";a="489743889"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@the-dreams.de>
Cc: Chew Kean Ho <kean.ho.chew@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: i801: enable Intel BayTrail SMBUS
Date: Sat,  1 Mar 2014 00:03:56 +0800
Message-Id: <1393603436-3494-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Kean ho <kean.ho.chew@intel.com>

Add Device ID of Intel BayTrail SMBus Controller.

Signed-off-by: Chew, Kean ho <kean.ho.chew@intel.com>
Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index aaaf0693..adf5e33 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -26,6 +26,7 @@ Supported adapters:
   * Intel Wellsburg (PCH)
   * Intel Coleto Creek (PCH)
   * Intel Wildcat Point-LP (PCH)
+  * Intel BayTrail (SOC)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index f5ed031..f23da0e 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -110,6 +110,7 @@ config I2C_I801
 	    Wellsburg (PCH)
 	    Coleto Creek (PCH)
 	    Wildcat Point-LP (PCH)
+	    BayTrail (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 349c2d3..899f559 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -60,6 +60,7 @@
   Wellsburg (PCH) MS    0x8d7f     32     hard     yes     yes     yes
   Coleto Creek (PCH)    0x23b0     32     hard     yes     yes     yes
   Wildcat Point-LP (PCH)   0x9ca2     32     hard     yes     yes     yes
+  BayTrail (SOC)        0x0f12     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -161,6 +162,7 @@
 				 STATUS_ERROR_FLAGS)
 
 /* Older devices have their ID defined in <linux/pci_ids.h> */
+#define PCI_DEVICE_ID_INTEL_BAYTRAIL_SMBUS	0x0f12
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
 /* Patsburg also has three 'Integrated Device Function' SMBus controllers */
@@ -822,6 +824,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COLETOCREEK_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BAYTRAIL_SMBUS) },
 	{ 0, }
 };
 
-- 
1.7.4.4

