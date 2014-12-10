Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbaLJOmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:42:15 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36939 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbaLJOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:42:13 -0500
Subject: [PATCH] staging, addi_apci_1500: fix IRQ spew
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 10 Dec 2014 14:42:01 +0000
Message-ID: <20141210144140.3964.42851.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver very carefully checks if the card is the IRQ source, and if it
isn't thoughtfully spews crap at_dev_warn() level. Remove the spewage so it
can be used on a shared interrupt line.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=88651
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 0ea081e..b7b9857 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -2175,10 +2175,6 @@ static void apci1500_interrupt(int irq, void *d)
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		/* Authorizes the main interrupt on the board */
 		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	} else {
-		dev_warn(dev->class_dev,
-			"Interrupt from unknown source\n");
-
 	}
 }
 

