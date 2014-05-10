Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaEJQYZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 12:24:25 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49197 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbaEJQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 12:24:24 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: ravi23ganiga@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: removing warnings reported by checkpatch tool on cb_pcimdas.c
Date: Sat, 10 May 2014 21:54:14 +0530
Message-Id: <1399739054-13570-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to remove warnings reported
by checkpatch tool on cb_pcimdas.c file

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index d3141c8..50e522e 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -31,7 +31,8 @@ Configuration Options:
 
 Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
 Only supports DIO, AO and simple AI in it's present form.
-No interrupts, multi channel or FIFO AI, although the card looks like it could support this.
+No interrupts, multi channel or FIFO AI,
+although the card looks like it could support this.
 See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
 */
 
@@ -128,8 +129,12 @@ static int cb_pcimdas_ai_rinsn(struct comedi_device *dev,
 		d = d & 0xfd;
 		outb(d, devpriv->BADR3 + 5);
 	}
-	outb(0x01, devpriv->BADR3 + 6);	/* set bursting off, conversions on */
-	outb(0x00, devpriv->BADR3 + 7);	/* set range to 10V. UP/BP is controlled by a switch on the board */
+
+	/* set bursting off, conversions on */
+	outb(0x01, devpriv->BADR3 + 6);
+
+	/* set range to 10V. UP/BP is controlled by a switch on the board */
+	outb(0x00, devpriv->BADR3 + 7);
 
 	/*
 	 * write channel limits to multiplexer, set Low (bits 0-3) and
-- 
1.7.10.4

