Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaIIKe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:34:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36217 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbaIIK1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:25 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 33/48] staging: comedi: ni_labpc_common: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:42 +0100
Message-Id: <1410258417-28230-34-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_labpc_common.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_common.c b/drivers/staging/comedi/drivers/ni_labpc_common.c
index c54c88d..35bc2c2 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_common.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_common.c
@@ -156,7 +156,7 @@ static void labpc_ai_set_chan_and_gain(struct comedi_device *dev,
 				       unsigned int range,
 				       unsigned int aref)
 {
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	struct labpc_private *devpriv = dev->private;
 
 	if (board->is_labpc1200) {
@@ -186,7 +186,7 @@ static void labpc_setup_cmd6_reg(struct comedi_device *dev,
 				 unsigned int aref,
 				 bool ena_intr)
 {
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	struct labpc_private *devpriv = dev->private;
 
 	if (!board->is_labpc1200)
@@ -544,7 +544,7 @@ static int labpc_ai_check_chanlist(struct comedi_device *dev,
 static int labpc_ai_cmdtest(struct comedi_device *dev,
 			    struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	int err = 0;
 	int tmp, tmp2;
 	unsigned int stop_mask;
@@ -652,7 +652,7 @@ static int labpc_ai_cmdtest(struct comedi_device *dev,
 
 static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	struct labpc_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -846,7 +846,7 @@ static void labpc_drain_dregs(struct comedi_device *dev)
 static irqreturn_t labpc_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	struct labpc_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
@@ -923,7 +923,7 @@ static int labpc_ao_insn_write(struct comedi_device *dev,
 			       struct comedi_insn *insn,
 			       unsigned int *data)
 {
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	struct labpc_private *devpriv = dev->private;
 	int channel, range;
 	unsigned long flags;
@@ -1248,7 +1248,7 @@ static int labpc_eeprom_insn_read(struct comedi_device *dev,
 int labpc_common_attach(struct comedi_device *dev,
 			unsigned int irq, unsigned long isr_flags)
 {
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	struct labpc_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	int ret;
-- 
2.1.0

