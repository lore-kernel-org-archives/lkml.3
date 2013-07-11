Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab3GKOvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:51:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3GKOZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wang YanQing <udknight@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 15/98] Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"
Date: Thu, 11 Jul 2013 15:23:45 +0100
Message-Id: <1373552708-15235-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 828c6a102b1f2b8583fadc0e779c46b31d448f0b upstream.

This reverts commit 8d2f8cd424ca0b99001f3ff4f5db87c4e525f366.

As reported by Stefan, this device already works with the parport_serial
driver, so the 8250_pci driver should not also try to grab it as well.

Reported-by: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: Wang YanQing <udknight@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/8250/8250_pci.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 92c954c..41c1db3 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4159,10 +4159,6 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
 
-	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
-		0x1000, 0x0012,
-		0, 0, pbn_b0_bt_2_115200 },
-
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 		0xA000, 0x1000,
 		0, 0, pbn_b0_1_115200 },
-- 
1.8.1.2

