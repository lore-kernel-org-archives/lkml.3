Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaFDXWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaFDXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Chew, Kean ho" <kean.ho.chew@intel.com>,
        "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@the-dreams.de>,
        "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 130/228] i2c: i801: enable Intel BayTrail SMBUS
Date: Wed,  4 Jun 2014 16:22:39 -0700
Message-Id: <20140604232352.202046308@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Chew, Kean ho" <kean.ho.chew@intel.com>

commit 1b31e9b76ef8c62291e698dfdb973499986a7f68 upstream.

Add Device ID of Intel BayTrail SMBus Controller.

Signed-off-by: Chew, Kean ho <kean.ho.chew@intel.com>
Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+)

--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -26,6 +26,7 @@ Supported adapters:
   * Intel Wellsburg (PCH)
   * Intel Coleto Creek (PCH)
   * Intel Wildcat Point-LP (PCH)
+  * Intel BayTrail (SOC)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -110,6 +110,7 @@ config I2C_I801
 	    Wellsburg (PCH)
 	    Coleto Creek (PCH)
 	    Wildcat Point-LP (PCH)
+	    BayTrail (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
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
@@ -822,6 +824,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids)
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COLETOCREEK_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BAYTRAIL_SMBUS) },
 	{ 0, }
 };
 


