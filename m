Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab3GKOtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:49:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42915 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab3GKOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shane Huang <shane.huang@amd.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 22/98] i2c-piix4: Add AMD CZ SMBus device ID
Date: Thu, 11 Jul 2013 15:23:52 +0100
Message-Id: <1373552708-15235-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit b996ac90f595dda271cbd858b136b45557fc1a57 upstream.

To add AMD CZ SMBus controller device ID.

[bhelgaas: drop pci_ids.h update]
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/i2c/busses/i2c-piix4 | 2 +-
 drivers/i2c/busses/Kconfig         | 1 +
 drivers/i2c/busses/i2c-piix4.c     | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/i2c/busses/i2c-piix4 b/Documentation/i2c/busses/i2c-piix4
index 475bb4a..65da157 100644
--- a/Documentation/i2c/busses/i2c-piix4
+++ b/Documentation/i2c/busses/i2c-piix4
@@ -8,7 +8,7 @@ Supported adapters:
     Datasheet: Only available via NDA from ServerWorks
   * ATI IXP200, IXP300, IXP400, SB600, SB700 and SB800 southbridges
     Datasheet: Not publicly available
-  * AMD Hudson-2
+  * AMD Hudson-2, CZ
     Datasheet: Not publicly available
   * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
     Datasheet: Publicly available at the SMSC website http://www.smsc.com
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 9b72abe..f2f2058 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -137,6 +137,7 @@ config I2C_PIIX4
 	    ATI SB700
 	    ATI SB800
 	    AMD Hudson-2
+	    AMD CZ
 	    Serverworks OSB4
 	    Serverworks CSB5
 	    Serverworks CSB6
diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index c14d48d..a356974 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -22,7 +22,7 @@
 	Intel PIIX4, 440MX
 	Serverworks OSB4, CSB5, CSB6, HT-1000, HT-1100
 	ATI IXP200, IXP300, IXP400, SB600, SB700, SB800
-	AMD Hudson-2
+	AMD Hudson-2, CZ
 	SMSC Victory66
 
    Note: we assume there can only be one device, with one SMBus interface.
@@ -481,6 +481,7 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x790b) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
-- 
1.8.1.2

