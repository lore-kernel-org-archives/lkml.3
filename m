Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaGKECR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:02:17 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:42093 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaGKECQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:02:16 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/4] staging: comedi: addi_apci_1564: remove len_chanlist from di and do subdevices
Date: Thu, 10 Jul 2014 23:01:26 -0500
Message-Id: <46eb3a46131c27b82fc1fdc6ad9ed412da187649.1405050794.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405050794.git.chase.southwood@gmail.com>
References: <cover.1405050794.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This value is only needed for subdevices that support async commands.
The comedi core will default the value to 1 when it is not initialized.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 5924421..675054f 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -385,7 +385,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_READABLE;
 	s->n_chan = 32;
 	s->maxdata = 1;
-	s->len_chanlist = 32;
 	s->range_table = &range_digital;
 	s->insn_bits = apci1564_di_insn_bits;
 
@@ -395,7 +394,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 32;
 	s->maxdata = 0xffffffff;
-	s->len_chanlist = 32;
 	s->range_table = &range_digital;
 	s->insn_config = apci1564_do_config;
 	s->insn_bits = apci1564_do_insn_bits;
-- 
2.0.1

