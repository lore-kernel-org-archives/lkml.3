Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab3LDUJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:09:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:38857 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504Ab3LDUJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:09:03 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Howard <lee.howard@mainpine.com>
Subject: [PATCH] parport: parport_pc: fix id print of a device
Date: Wed,  4 Dec 2013 21:08:55 +0100
Message-Id: <1386187735-13900-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7106b4e3 ("8250: Oxford Semiconductor Devices") the debug
print of the device id does no longer match the real device if it is
located in the "enum" behind oxsemi_pcie_pport. The reason is that the
code assumes that each id contains one entry in the PCI table.
The fix is to lookup the currently used id from the id-> parameter.

Cc: Lee Howard <lee.howard@mainpine.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/parport/parport_pc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index b0a0d53..3cdb60d 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2817,16 +2817,12 @@ static int parport_pc_pci_probe(struct pci_dev *dev,
 		if (irq == IRQ_NONE) {
 			printk(KERN_DEBUG
 	"PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx)\n",
-				parport_pc_pci_tbl[i + last_sio].vendor,
-				parport_pc_pci_tbl[i + last_sio].device,
-				io_lo, io_hi);
+				id->vendor, id->device, io_lo, io_hi);
 			irq = PARPORT_IRQ_NONE;
 		} else {
 			printk(KERN_DEBUG
 	"PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx), IRQ %d\n",
-				parport_pc_pci_tbl[i + last_sio].vendor,
-				parport_pc_pci_tbl[i + last_sio].device,
-				io_lo, io_hi, irq);
+				id->vendor, id->device, io_lo, io_hi, irq);
 		}
 		data->ports[count] =
 			parport_pc_probe_port(io_lo, io_hi, irq,
-- 
1.8.4.4

