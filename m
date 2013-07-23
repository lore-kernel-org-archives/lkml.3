Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817Ab3GWWrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:47:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934619Ab3GWW10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shane Huang <shane.huang@amd.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: [ 045/103] i2c-piix4: Add AMD CZ SMBus device ID
Date: Tue, 23 Jul 2013 15:25:56 -0700
Message-Id: <20130723220423.601450524@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit b996ac90f595dda271cbd858b136b45557fc1a57 upstream.

To add AMD CZ SMBus controller device ID.

[bhelgaas: drop pci_ids.h update]
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/i2c/busses/i2c-piix4 |    2 +-
 drivers/i2c/busses/Kconfig         |    1 +
 drivers/i2c/busses/i2c-piix4.c     |    3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/i2c/busses/i2c-piix4
+++ b/Documentation/i2c/busses/i2c-piix4
@@ -13,7 +13,7 @@ Supported adapters:
   * AMD SP5100 (SB700 derivative found on some server mainboards)
     Datasheet: Publicly available at the AMD website
     http://support.amd.com/us/Embedded_TechDocs/44413.pdf
-  * AMD Hudson-2
+  * AMD Hudson-2, CZ
     Datasheet: Not publicly available
   * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
     Datasheet: Publicly available at the SMSC website http://www.smsc.com
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -150,6 +150,7 @@ config I2C_PIIX4
 	    ATI SB700/SP5100
 	    ATI SB800
 	    AMD Hudson-2
+	    AMD CZ
 	    Serverworks OSB4
 	    Serverworks CSB5
 	    Serverworks CSB6
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -22,7 +22,7 @@
 	Intel PIIX4, 440MX
 	Serverworks OSB4, CSB5, CSB6, HT-1000, HT-1100
 	ATI IXP200, IXP300, IXP400, SB600, SB700/SP5100, SB800
-	AMD Hudson-2
+	AMD Hudson-2, CZ
 	SMSC Victory66
 
    Note: we assume there can only be one device, with one or more
@@ -522,6 +522,7 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_HUDSON2_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x790b) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
 		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,


