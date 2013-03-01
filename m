Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3CADq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 22:46:29 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:48462 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CADq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 22:46:27 -0500
Date: Fri, 1 Mar 2013 11:47:20 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com
Subject: [PATCH]serial: 8250_pci: add support for another kind of NetMos
 Technology PCI 9835 Multi-I/O Controller
Message-ID: <20130301034719.GA5728@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org, alan@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

01:08.0 Communication controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01)
	Subsystem: Device [1000:0012]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at e050 [size=8]
	Region 1: I/O ports at e040 [size=8]
	Region 2: I/O ports at e030 [size=8]
	Region 3: I/O ports at e020 [size=8]
	Region 4: I/O ports at e010 [size=8]
	Region 5: I/O ports at e000 [size=16]

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/serial/8250/8250_pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 791c5a7..ebcc362 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4791,6 +4791,10 @@ static struct pci_device_id serial_pci_tbl[] = {
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
1.7.11.1.116.g8228a23
