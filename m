Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaGKEDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:03:35 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35383 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaGKEDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:03:34 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 4/4] staging: comedi: addi_apci_1564: fix s->maxdata assignment in do subdevice init.
Date: Thu, 10 Jul 2014 23:02:55 -0500
Message-Id: <0f61da14def4ff76d9a2bc5c0dcc0b16bd5cb0ec.1405050794.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405050794.git.chase.southwood@gmail.com>
References: <cover.1405050794.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s->maxdata for the do subdevice should be 1, however currently it is
being set to 0xffffffff.  Fix this.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
This patch is at the end because I'm somewhat uncertain of its
correctness.  Every other addi_apci_* driver with a digital output
subdevice sets s->maxdata to 1 so I'd be surprised if just this board
differed, but I'm not familiar enough with the hardware to verify that
myself.  I'd appreciate a verification that this is a correct change.
Thanks!

 drivers/staging/comedi/drivers/addi_apci_1564.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index f91aedd..1e25342 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -391,7 +391,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->type = COMEDI_SUBD_DO;
 	s->subdev_flags = SDF_WRITEABLE;
 	s->n_chan = 32;
-	s->maxdata = 0xffffffff;
+	s->maxdata = 1;
 	s->range_table = &range_digital;
 	s->insn_config = apci1564_do_config;
 	s->insn_bits = apci1564_do_insn_bits;
-- 
2.0.1

