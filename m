Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbaEEMxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:53:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41009 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932291AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Chew, Kean ho" <kean.ho.chew@intel.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 11/50] i2c: i801: enable Intel BayTrail SMBUS
Date: Mon,  5 May 2014 14:42:53 +0200
Message-Id: <008c29f91e856d2e46104c082baaa518832bd2a3.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chew, Kean ho" <kean.ho.chew@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1b31e9b76ef8c62291e698dfdb973499986a7f68 upstream.

Add Device ID of Intel BayTrail SMBus Controller.

Signed-off-by: Chew, Kean ho <kean.ho.chew@intel.com>
Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/i2c/busses/i2c-i801 | 1 +
 drivers/i2c/busses/Kconfig        | 1 +
 drivers/i2c/busses/i2c-i801.c     | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index 7b0dcdb57173..babe2ef16139 100644
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
index 4e901081e287..01892bdfa7b7 100644
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
index 737e29866887..0444f7aa1046 100644
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
1.9.2

