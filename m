Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbaIIKnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:43:31 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36145 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329AbaIIK1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:11 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/48] staging: comedi: addi_common: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:10 +0100
Message-Id: <1410258417-28230-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
References: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `comedi_board(dev)` inline function calls just return
`dev->board_ptr`.  Expand the inline function calls.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/addi-data/addi_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 025b451..2e7fb21 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -44,7 +44,7 @@ static int i_ADDIDATA_InsnReadEeprom(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	unsigned short w_Address = CR_CHAN(insn->chanspec);
 	unsigned short w_Data;
@@ -59,7 +59,7 @@ static int i_ADDIDATA_InsnReadEeprom(struct comedi_device *dev,
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 
 	this_board->interrupt(irq, d);
 	return IRQ_RETVAL(1);
@@ -67,7 +67,7 @@ static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 
 static int i_ADDI_Reset(struct comedi_device *dev)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 
 	this_board->reset(dev);
 	return 0;
@@ -77,7 +77,7 @@ static int addi_auto_attach(struct comedi_device *dev,
 				      unsigned long context_unused)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret, n_subdevices;
-- 
2.1.0

