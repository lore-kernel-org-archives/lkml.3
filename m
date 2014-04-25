Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaDYISc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:18:32 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53070 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaDYISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:18:24 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/2] staging: comedi: addi_apci_1564: board does not have analog outputs
Date: Fri, 25 Apr 2014 03:18:10 -0500
Message-Id: <1398413890-19672-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398413826-19400-1-git-send-email-chase.southwood@gmail.com>
References: <1398413826-19400-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board supported by this driver does not have analog outputs.  Remove
the subdevice init for it.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
Compile tested only.

 drivers/staging/comedi/drivers/addi_apci_1564.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index eee10cc..5f6d3b5 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -148,17 +148,8 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 	/*  Allocate and Initialise AO Subdevice Structures */
 	s = &dev->subdevices[1];
-	if (devpriv->s_EeParameters.i_NbrAoChannel) {
-		s->type = COMEDI_SUBD_AO;
-		s->subdev_flags = SDF_WRITEABLE | SDF_GROUND | SDF_COMMON;
-		s->n_chan = devpriv->s_EeParameters.i_NbrAoChannel;
-		s->maxdata = devpriv->s_EeParameters.i_AoMaxdata;
-		s->len_chanlist =
-			devpriv->s_EeParameters.i_NbrAoChannel;
-		s->insn_write = this_board->ao_write;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
+	s->type = COMEDI_SUBD_UNUSED;
+
 	/*  Allocate and Initialise DI Subdevice Structures */
 	s = &dev->subdevices[2];
 	if (devpriv->s_EeParameters.i_NbrDiChannel) {
-- 
1.9.0

