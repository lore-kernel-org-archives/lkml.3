Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaDYIRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:17:47 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56304 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDYIR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:17:27 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/2] staging: comedi: addi_apci_1564: board does not have analog inputs
Date: Fri, 25 Apr 2014 03:17:06 -0500
Message-Id: <1398413826-19400-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This board does not have analog inputs.  Remove the subdevice init for
them.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
Compile tested only.  To be applied on top of
[PATCH] staging: comedi: addi_apci_1564: separate from addi_common.c

 drivers/staging/comedi/drivers/addi_apci_1564.c | 31 +------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 792916d..eee10cc 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -144,36 +144,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise AI Subdevice Structures */
 	s = &dev->subdevices[0];
-	if ((devpriv->s_EeParameters.i_NbrAiChannel)
-		|| (this_board->i_NbrAiChannelDiff)) {
-		dev->read_subdev = s;
-		s->type = COMEDI_SUBD_AI;
-		s->subdev_flags =
-			SDF_READABLE | SDF_COMMON | SDF_GROUND
-			| SDF_DIFF;
-		if (devpriv->s_EeParameters.i_NbrAiChannel) {
-			s->n_chan =
-				devpriv->s_EeParameters.i_NbrAiChannel;
-			devpriv->b_SingelDiff = 0;
-		} else {
-			s->n_chan = this_board->i_NbrAiChannelDiff;
-			devpriv->b_SingelDiff = 1;
-		}
-		s->maxdata = devpriv->s_EeParameters.i_AiMaxdata;
-		s->len_chanlist = this_board->i_AiChannelList;
-		s->range_table = this_board->pr_AiRangelist;
-
-		s->insn_config = this_board->ai_config;
-		s->insn_read = this_board->ai_read;
-		s->insn_write = this_board->ai_write;
-		s->insn_bits = this_board->ai_bits;
-		s->do_cmdtest = this_board->ai_cmdtest;
-		s->do_cmd = this_board->ai_cmd;
-		s->cancel = this_board->ai_cancel;
-
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+	s->type = COMEDI_SUBD_UNUSED;
 
 	/*  Allocate and Initialise AO Subdevice Structures */
 	s = &dev->subdevices[1];
-- 
1.9.0

