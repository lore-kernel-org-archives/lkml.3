Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaBKTIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:08:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaBKTIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Chan, Wei Sern" <wei.sern.chan@intel.com>
Subject: [PATCH 3.10 67/79] i2c: i801: SMBus patch for Intel Coleto Creek DeviceIDs
Date: Tue, 11 Feb 2014 11:06:11 -0800
Message-Id: <20140211184722.911744620@linuxfoundation.org>
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

commit f39901c1befa556bc91902516a3e2e460000b4a8 upstream.

This patch adds the i801 SMBus Controller DeviceIDs for the Intel Coleto Creek PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: "Chan, Wei Sern" <wei.sern.chan@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+)

--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -24,6 +24,7 @@ Supported adapters:
   * Intel Lynx Point-LP (PCH)
   * Intel Avoton (SOC)
   * Intel Wellsburg (PCH)
+  * Intel Coleto Creek (PCH)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -108,6 +108,7 @@ config I2C_I801
 	    Lynx Point-LP (PCH)
 	    Avoton (SOC)
 	    Wellsburg (PCH)
+	    Coleto Creek (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
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
@@ -817,6 +819,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids)
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COLETOCREEK_SMBUS) },
 	{ 0, }
 };
 


