Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaG2MAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:00:34 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51676 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbaG2L6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:49 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] staging: comedi: amplc_pci230: no need for '&function'
Date: Tue, 29 Jul 2014 12:58:23 +0100
Message-Id: <1406635107-27950-16-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "address-of" operator when the operand is a function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index c2da10c..395eba2 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2746,13 +2746,13 @@ static int pci230_attach_common(struct comedi_device *dev,
 	s->n_chan = thisboard->ai_chans;
 	s->maxdata = (1 << thisboard->ai_bits) - 1;
 	s->range_table = &pci230_ai_range;
-	s->insn_read = &pci230_ai_rinsn;
+	s->insn_read = pci230_ai_rinsn;
 	s->len_chanlist = 256;	/* but there are restrictions. */
 	if (dev->irq) {
 		dev->read_subdev = s;
 		s->subdev_flags |= SDF_CMD_READ;
-		s->do_cmd = &pci230_ai_cmd;
-		s->do_cmdtest = &pci230_ai_cmdtest;
+		s->do_cmd = pci230_ai_cmd;
+		s->do_cmdtest = pci230_ai_cmdtest;
 		s->cancel = pci230_ai_cancel;
 	}
 
@@ -2764,14 +2764,14 @@ static int pci230_attach_common(struct comedi_device *dev,
 		s->n_chan = thisboard->ao_chans;
 		s->maxdata = (1 << thisboard->ao_bits) - 1;
 		s->range_table = &pci230_ao_range;
-		s->insn_write = &pci230_ao_winsn;
-		s->insn_read = &pci230_ao_rinsn;
+		s->insn_write = pci230_ao_winsn;
+		s->insn_read = pci230_ao_rinsn;
 		s->len_chanlist = thisboard->ao_chans;
 		if (dev->irq) {
 			dev->write_subdev = s;
 			s->subdev_flags |= SDF_CMD_WRITE;
-			s->do_cmd = &pci230_ao_cmd;
-			s->do_cmdtest = &pci230_ao_cmdtest;
+			s->do_cmd = pci230_ao_cmd;
+			s->do_cmdtest = pci230_ao_cmdtest;
 			s->cancel = pci230_ao_cancel;
 		}
 	} else {
-- 
2.0.0

