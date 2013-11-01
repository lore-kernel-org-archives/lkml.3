Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3KAMca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:32:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63804 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3KAMc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:32:28 -0400
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: joe@perches.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH] Staging: comedi: fix coding style issues in unioxx5.c
Date: Fri,  1 Nov 2013 18:01:56 +0530
Message-Id: <1383309116-8042-1-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch which fixes  coding style issues in unioxx5.c found
by checkpatch.pl

1) Replaced printk with pr_info and pr_err
2) Reinitialized n_subd before for loop to fix over 80 character
   warning
3) Reworded comment to fix 80 character warning

Signed-off-by: Conrad Gomes <conrad.s.j.gomes@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 93eec2f..de68e3a 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -96,7 +96,7 @@ static void __unioxx5_digital_config(struct unioxx5_subd_priv *usp, int mode)
 	int i, mask;
 
 	mask = (mode == ALL_2_OUTPUT) ? 0xFF : 0x00;
-	printk("COMEDI: mode = %d\n", mask);
+	pr_info("COMEDI: mode = %d\n", mask);
 
 	outb(1, usp->usp_iobase + 0);
 
@@ -185,7 +185,7 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 
 	/* if four bytes readding error occurs - return 0(false) */
 	if ((control & Rx4CA_ERR_MASK)) {
-		printk("COMEDI: 4 bytes error\n");
+		pr_err("COMEDI: 4 bytes error\n");
 		return 0;
 	}
 
@@ -436,8 +436,10 @@ static int unioxx5_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	iobase += UNIOXX5_SUBDEV_BASE;
 
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
-	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
+	n_subd = 0;
+
+	/* getting number of subdevices with types 'g01'*/
+	for (i = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
 
-- 
1.7.9.5

