Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3GXOVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:21:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45856 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab3GXOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wang YanQing" <udknight@gmail.com>,
        "Stefan Seyfried" <stefan.seyfried@googlemail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.159641193@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [55/85] Revert "serial: 8250_pci: add support for another kind of
 NetMos Technology PCI 9835 Multi-I/O Controller"
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 828c6a102b1f2b8583fadc0e779c46b31d448f0b upstream.

This reverts commit 8d2f8cd424ca0b99001f3ff4f5db87c4e525f366.

As reported by Stefan, this device already works with the parport_serial
driver, so the 8250_pci driver should not also try to grab it as well.

Reported-by: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Wang YanQing <udknight@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/8250_pci.c | 4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -4083,10 +4083,6 @@ static struct pci_device_id serial_pci_t
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
 
-	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
-		0x1000, 0x0012,
-		0, 0, pbn_b0_bt_2_115200 },
-
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 		0xA000, 0x1000,
 		0, 0, pbn_b0_1_115200 },

