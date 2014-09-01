Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaIALIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:08:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39018 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbaIALEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/28] staging: comedi: amplc_pci230: rename pci230_ai_rinsn()
Date: Mon,  1 Sep 2014 12:03:49 +0100
Message-Id: <1409569440-10979-18-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the AI subdevice "insn_read" handler function `pci230_ai_rinsn()`
to `pci230_ai_insn_read()` for consistency.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index d832268..72da4b6 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -774,9 +774,9 @@ static int pci230_ai_eoc(struct comedi_device *dev,
 	return -EBUSY;
 }
 
-static int pci230_ai_rinsn(struct comedi_device *dev,
-			   struct comedi_subdevice *s, struct comedi_insn *insn,
-			   unsigned int *data)
+static int pci230_ai_insn_read(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
 {
 	struct pci230_private *devpriv = dev->private;
 	unsigned int n;
@@ -2649,7 +2649,7 @@ static int pci230_auto_attach(struct comedi_device *dev,
 	s->n_chan = 16;
 	s->maxdata = (1 << thisboard->ai_bits) - 1;
 	s->range_table = &pci230_ai_range;
-	s->insn_read = pci230_ai_rinsn;
+	s->insn_read = pci230_ai_insn_read;
 	s->len_chanlist = 256;	/* but there are restrictions. */
 	if (dev->irq) {
 		dev->read_subdev = s;
-- 
2.0.4

