Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaHSPGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:06:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58315 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaHSPGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:06:49 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging: comedi: ni_labpc: use braces on all arms of `if` statement
Date: Tue, 19 Aug 2014 16:06:29 +0100
Message-Id: <1408460793-29793-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
References: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issues "CHECK: braces {} should be used on all arms of
this statement".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index f5e78ad..4f49d51 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -397,8 +397,9 @@ static void labpc_set_ai_convert_period(struct comedi_cmd *cmd,
 		cmd->scan_begin_arg = ns;
 		if (cmd->convert_arg > cmd->scan_begin_arg)
 			cmd->convert_arg = cmd->scan_begin_arg;
-	} else
+	} else {
 		cmd->convert_arg = ns;
+	}
 }
 
 static unsigned int labpc_ai_scan_period(const struct comedi_cmd *cmd,
@@ -1409,8 +1410,9 @@ int labpc_common_attach(struct comedi_device *dev,
 
 		for (i = 0; i < s->n_chan; i++)
 			write_caldac(dev, i, s->maxdata / 2);
-	} else
+	} else {
 		s->type		= COMEDI_SUBD_UNUSED;
+	}
 
 	/* EEPROM */
 	s = &dev->subdevices[4];
@@ -1424,8 +1426,9 @@ int labpc_common_attach(struct comedi_device *dev,
 
 		for (i = 0; i < s->n_chan; i++)
 			devpriv->eeprom_data[i] = labpc_eeprom_read(dev, i);
-	} else
+	} else {
 		s->type		= COMEDI_SUBD_UNUSED;
+	}
 
 	return 0;
 }
-- 
2.0.4

