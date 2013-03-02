Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3CBJpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 04:45:15 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35678 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3CBJpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 04:45:09 -0500
Date: Sat, 2 Mar 2013 17:45:55 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swarren@wwwdotorg.org, jslaby@suse.cz, alan@linux.intel.com, arnd@arndb.de,
        paul.gortmaker@windriver.com, damm@opensource.se,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]8250_pci: Add additional WCH CH352 device
Message-ID: <20130302094555.GA9572@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, swarren@wwwdotorg.org, jslaby@suse.cz,
	alan@linux.intel.com, arnd@arndb.de, paul.gortmaker@windriver.com,
	damm@opensource.se, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a problem XScale port
detect code in autoconfig_16550a treat
16550A port as XScale port, caused by
CH352 device use the 6th bit(UART_IER_UUE)
in IER as a enhance function make this bit
w/r.

for the below device:
"
01:08.0 Serial controller: Device 4348:3253 (rev 10) (prog-if 02 [16550])
	Subsystem: Device 4348:3253
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at e010 [size=8]
	Region 1: I/O ports at e000 [size=8]
	Kernel driver in use: serial
"
[Note: I haven't test this patch, because I can't
access the hardware now, but it should be right]

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/serial/8250/8250_pci.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index ebcc362..be45d39 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1557,6 +1557,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_WCH_CH353_4S	0x3453
 #define PCI_DEVICE_ID_WCH_CH353_2S1PF	0x5046
 #define PCI_DEVICE_ID_WCH_CH353_2S1P	0x7053
+#define PCI_DEVICE_ID_WCH_CH352_2S	0x3253
 #define PCI_VENDOR_ID_AGESTAR		0x5372
 #define PCI_DEVICE_ID_AGESTAR_9375	0x6872
 #define PCI_VENDOR_ID_ASIX		0x9710
@@ -2180,6 +2181,14 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch353_setup,
 	},
+	/* WCH CH352 2S card (16550 clone) */
+	{
+		.vendor         = PCI_VENDOR_ID_WCH,
+		.device         = PCI_DEVICE_ID_WCH_CH352_2S,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = pci_wch_ch353_setup,
+	},
 	/*
 	 * ASIX devices with FIFO bug
 	 */
@@ -4873,6 +4882,10 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_b0_bt_2_115200 },
 
+	{	PCI_VENDOR_ID_WCH, PCI_DEVICE_ID_WCH_CH352_2S,
+		PCI_ANY_ID, PCI_ANY_ID,
+		0, 0, pbn_b0_bt_2_115200 },
+
 	/*
 	 * Commtech, Inc. Fastcom adapters
 	 */
-- 
1.7.11.1.116.g8228a23
