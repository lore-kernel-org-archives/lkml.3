Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3GAHPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:15:34 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:55691 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3GAHPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:15:33 -0400
From: stefan.seyfried@googlemail.com
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Stefan Seyfried <seife+kernel@b1-systems.com>
Subject: [PATCH] 8250_pci: improve code comments and Kconfig help
Date: Mon,  1 Jul 2013 09:14:21 +0200
Message-Id: <1372662861-11231-2-git-send-email-stefan.seyfried@googlemail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372662861-11231-1-git-send-email-stefan.seyfried@googlemail.com>
References: <20130630160226.GA26644@kroah.com>
 <1372662861-11231-1-git-send-email-stefan.seyfried@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife+kernel@b1-systems.com>

The recent regression about NetMos 9835 Multi-I/O boards indicates
that comment pointing to the parport_serial driver could be helpful.

Signed-off-by: Stefan Seyfried <seife+kernel@b1-systems.com>
---
 drivers/tty/serial/8250/8250_pci.c | 6 ++++++
 drivers/tty/serial/8250/Kconfig    | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index c52948b..c626c4f 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -4797,6 +4797,12 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
 
+	/*
+	 * other NetMos 9835 devices are most likely handled by the
+	 * parport_serial driver, check drivers/parport/parport_serial.c
+	 * before adding them here.
+	 */
+
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 		0xA000, 0x1000,
 		0, 0, pbn_b0_1_115200 },
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index a1ba94d..f3b306e 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -116,6 +116,8 @@ config SERIAL_8250_PCI
 	  This builds standard PCI serial support. You may be able to
 	  disable this feature if you only need legacy serial support.
 	  Saves about 9K.
+	  Note that serial ports on NetMos 9835 Multi-I/O cards are handled
+	  by the parport_serial driver, enabled with CONFIG_PARPORT_SERIAL.
 
 config SERIAL_8250_HP300
 	tristate
-- 
1.8.3.1

