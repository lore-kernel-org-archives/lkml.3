Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3LJIj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:39:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3LJH7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: [PATCH 3.4 20/25] i2c: i801: SMBus patch for Intel Avoton DeviceIDs
Date: Tue, 10 Dec 2013 00:00:28 -0800
Message-Id: <20131210075932.238300592@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit c2db409cbc8751ccc7e6d2cc2e41af0d12ea637f upstream.

This patch adds the PCU SMBus DeviceID for the Intel Avoton SOC.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: "Ong, Boon Leong" <boon.leong.ong@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+)

--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -22,6 +22,7 @@ Supported adapters:
   * Intel Panther Point (PCH)
   * Intel Lynx Point (PCH)
   * Intel Lynx Point-LP (PCH)
+  * Intel Avoton (SOC)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -105,6 +105,7 @@ config I2C_I801
 	    Panther Point (PCH)
 	    Lynx Point (PCH)
 	    Lynx Point-LP (PCH)
+	    Avoton (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
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
@@ -639,6 +641,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids)
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_AVOTON_SMBUS) },
 	{ 0, }
 };
 


