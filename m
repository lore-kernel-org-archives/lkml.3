Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaD0BhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 21:37:13 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38167 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaD0BhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 21:37:10 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/6] staging: comedi: addi_apci_1032: board has 32 digital inputs
Date: Sat, 26 Apr 2014 20:37:03 -0500
Message-Id: <1398562623-5727-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This board always has 32 digital inputs. Remove the test when
initializing the subdevice.

Also, since this board is the only one supported by this driver,
remove the boardinfo about the digital inputs and just use the
data directly in the subdevice init.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 26 +++++++++----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index c84e17c..fe42f9d 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -20,8 +20,6 @@ static const struct addi_board apci1564_boardtypes[] = {
 		.i_Timer		= 1,
 		.interrupt		= apci1564_interrupt,
 		.reset			= apci1564_reset,
-		.di_config		= apci1564_di_config,
-		.di_bits		= apci1564_di_insn_bits,
 		.do_config		= apci1564_do_config,
 		.do_bits		= apci1564_do_insn_bits,
 		.do_read		= apci1564_do_read,
@@ -115,21 +113,15 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise DI Subdevice Structures */
 	s = &dev->subdevices[2];
-	if (devpriv->s_EeParameters.i_NbrDiChannel) {
-		s->type = COMEDI_SUBD_DI;
-		s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = devpriv->s_EeParameters.i_NbrDiChannel;
-		s->maxdata = 1;
-		s->len_chanlist =
-			devpriv->s_EeParameters.i_NbrDiChannel;
-		s->range_table = &range_digital;
-		s->insn_config = this_board->di_config;
-		s->insn_read = this_board->di_read;
-		s->insn_write = this_board->di_write;
-		s->insn_bits = this_board->di_bits;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+	s->type = COMEDI_SUBD_DI;
+	s->subdev_flags = SDF_READABLE;
+	s->n_chan = 32;
+	s->maxdata = 1;
+	s->len_chanlist = 32;
+	s->range_table = &range_digital;
+	s->insn_config = apci1564_di_config;
+	s->insn_bits = apci1564_di_insn_bits;
+
 	/*  Allocate and Initialise DO Subdevice Structures */
 	s = &dev->subdevices[3];
 	if (devpriv->s_EeParameters.i_NbrDoChannel) {
-- 
1.9.0

