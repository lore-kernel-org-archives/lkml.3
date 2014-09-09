Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaIIK1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36142 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327AbaIIK1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:10 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/48] staging: comedi: addi_apci_3120: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:13 +0100
Message-Id: <1410258417-28230-5-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c | 10 +++++-----
 drivers/staging/comedi/drivers/addi_apci_3120.c           |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 87dff80..a83e2ae 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -253,7 +253,7 @@ static int apci3120_ai_insn_config(struct comedi_device *dev,
 				   struct comedi_insn *insn,
 				   unsigned int *data)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	unsigned int i;
 
@@ -359,7 +359,7 @@ static int apci3120_ai_insn_read(struct comedi_device *dev,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	unsigned short us_ConvertTiming, us_TmpValue, i;
 	unsigned char b_Tmp;
@@ -802,7 +802,7 @@ static int apci3120_cyclic_ai(int mode,
 			      struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned char b_Tmp;
@@ -1728,7 +1728,7 @@ static int apci3120_config_insn_timer(struct comedi_device *dev,
 				      struct comedi_insn *insn,
 				      unsigned int *data)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Timervalue2;
 	unsigned short us_TmpValue;
@@ -1873,7 +1873,7 @@ static int apci3120_write_insn_timer(struct comedi_device *dev,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Timervalue2 = 0;
 	unsigned short us_TmpValue;
diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index 050c724..84501a3 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -44,7 +44,7 @@ static const struct addi_board apci3120_boardtypes[] = {
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	const struct addi_board *this_board = comedi_board(dev);
+	const struct addi_board *this_board = dev->board_ptr;
 
 	this_board->interrupt(irq, d);
 	return IRQ_RETVAL(1);
-- 
2.1.0

