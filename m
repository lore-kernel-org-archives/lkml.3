Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab3GPPZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:25:43 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:56317 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab3GPPZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:25:34 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: linux-pci@vger.kernel.org, linux-serial@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3/4] serial: 8250_pci: use local device ID for ADDI-DATA APCI-7800
Date: Tue, 16 Jul 2013 16:14:40 +0100
Message-Id: <1373987681-18245-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
References: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The quirks and PCI ID table entries for the original ADDI-DATA APCI-7800
(not the newer APCI-7800-3) use PCI_DEVICE_ID_ADDIDATA_APCI7800 from
<linux/pci_ids.h> but the device ID was actually assigned to ADDI-DATA
by Applied Micro Circuits Corporation (PCI_VENDOR_ID_AMCC).  Replace it
locally with #define PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/tty/serial/8250/8250_pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 3e3d59b..e9b915c 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1565,6 +1565,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_COMMTECH_4228PCIE	0x0021
 #define PCI_DEVICE_ID_COMMTECH_4222PCIE	0x0022
 #define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
+#define PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800 0x818e
 
 #define PCI_VENDOR_ID_SUNIX		0x1fd4
 #define PCI_DEVICE_ID_SUNIX_1999	0x1999
@@ -1588,7 +1589,7 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 	*/
 	{
 		.vendor         = PCI_VENDOR_ID_AMCC,
-		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		.device         = PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = addidata_apci7800_setup,
@@ -4698,7 +4699,7 @@ static struct pci_device_id serial_pci_tbl[] = {
 		pbn_b0_1_115200 },
 
 	{	PCI_VENDOR_ID_AMCC,
-		PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800,
 		PCI_ANY_ID,
 		PCI_ANY_ID,
 		0,
-- 
1.8.2.1

