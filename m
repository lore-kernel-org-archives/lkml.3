Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3GKWMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:12:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab3GKWLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:11:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Seyfried <stefan.seyfried@googlemail.com>,
        Wang YanQing <udknight@gmail.com>
Subject: [ 08/11] Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"
Date: Thu, 11 Jul 2013 15:11:08 -0700
Message-Id: <20130711220546.493864099@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711220545.542911892@linuxfoundation.org>
References: <20130711220545.542911892@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 828c6a102b1f2b8583fadc0e779c46b31d448f0b upstream.

This reverts commit 8d2f8cd424ca0b99001f3ff4f5db87c4e525f366.

As reported by Stefan, this device already works with the parport_serial
driver, so the 8250_pci driver should not also try to grab it as well.

Reported-by: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Wang YanQing <udknight@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4086,10 +4086,6 @@ static struct pci_device_id serial_pci_t
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
 
-	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
-		0x1000, 0x0012,
-		0, 0, pbn_b0_bt_2_115200 },
-
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 		0xA000, 0x1000,
 		0, 0, pbn_b0_1_115200 },


