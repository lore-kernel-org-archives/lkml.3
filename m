Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3CEPoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:44:06 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59790 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3CEPoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:44:02 -0500
Date: Tue, 5 Mar 2013 23:44:48 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: paul.gortmaker@windriver.com, swarren@wwwdotorg.org, jslaby@suse.cz,
        alan@linux.intel.com, arnd@arndb.de, damm@opensource.se,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2]serial: 8250_pci: add device id for a kind of Multi-I/O
 Controller based on NetMos Technology PCI 9835
Message-ID: <20130305154448.GA7842@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, paul.gortmaker@windriver.com,
	swarren@wwwdotorg.org, jslaby@suse.cz, alan@linux.intel.com,
	arnd@arndb.de, damm@opensource.se, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get a Multi-I/O Controller below:
01:08.0 Communication controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01)
        Subsystem: LSI Logic / Symbios Logic 1P2S
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at e050 [size=8]
	Region 1: I/O ports at e040 [size=8]
	Region 2: I/O ports at e030 [size=8]
	Region 3: I/O ports at e020 [size=8]
	Region 4: I/O ports at e010 [size=8]
	Region 5: I/O ports at e000 [size=16]

I get below from pci.ids:
9710  NetMos Technology
        9835  PCI 9835 Multi-I/O Controller
                1000 0002  2S (16C550 UART)
                1000 0012  1P2S
I have tested 8250_pci.c, it works well with it,
so we just need add the device id to the deivce
id table.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
Changes:
V1-V2:
1: use a better descriptive subject
2: add more detail log

Thanks
 drivers/tty/serial/8250/8250_pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 5805f89..2120840 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4800,6 +4800,10 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
 
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
+		0x1000, 0x0012,
+		0, 0, pbn_b0_bt_2_115200 },
+
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 		0xA000, 0x1000,
 		0, 0, pbn_b0_1_115200 },
-- 
1.7.12.4.dirty
