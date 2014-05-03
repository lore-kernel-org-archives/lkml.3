Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaECH5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 03:57:53 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35986 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaECH5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 03:57:52 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 4/4] staging: comedi: addi_apci_1564: call apci1564_interrupt() directly
Date: Sat,  3 May 2014 02:57:41 -0500
Message-Id: <1399103861-16342-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
References: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the boardinfo about the interrupt function and just call it
directly.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 254889a..df1a16e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -15,7 +15,6 @@ static const struct addi_board apci1564_boardtypes[] = {
 		.i_NbrDoChannel		= 32,
 		.i_DoMaxdata		= 0xffffffff,
 		.i_Timer		= 1,
-		.interrupt		= apci1564_interrupt,
 		.timer_config		= apci1564_timer_config,
 		.timer_write		= apci1564_timer_write,
 		.timer_read		= apci1564_timer_read,
@@ -24,10 +23,7 @@ static const struct addi_board apci1564_boardtypes[] = {
 
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
-	struct comedi_device *dev = d;
-	const struct addi_board *this_board = comedi_board(dev);
-
-	this_board->interrupt(irq, d);
+	apci1564_interrupt(irq, d);
 	return IRQ_RETVAL(1);
 }
 
-- 
1.9.0

