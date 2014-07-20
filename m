Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaGTOHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:07:25 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47658 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaGTOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:50 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 2/7] Staging: comedi: adv_pci1710: a line over 80 issue fixed
Date: Sun, 20 Jul 2014 17:06:19 +0300
Message-Id: <1405865185-8375-2-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
References: <1405865185-8375-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By removing a comment to previous line, 'line over 80' issue
fixed.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index a15a552..b4b8f85 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -1049,7 +1049,8 @@ static int pci171x_reset(struct comedi_device *dev)
 	struct pci1710_private *devpriv = dev->private;
 
 	outw(0x30, dev->iobase + PCI171x_CNTCTRL);
-	devpriv->CntrlReg = Control_SW | Control_CNT0;	/*  Software trigger, CNT0=external */
+	/* Software trigger, CNT0=external */
+	devpriv->CntrlReg = Control_SW | Control_CNT0;
 	outw(devpriv->CntrlReg, dev->iobase + PCI171x_CONTROL);	/*  reset any operations */
 	outb(0, dev->iobase + PCI171x_CLRFIFO);	/*  clear FIFO */
 	outb(0, dev->iobase + PCI171x_CLRINT);	/*  clear INT request */
-- 
1.7.10.4

