Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbaIIKlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:41:47 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36171 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367AbaIIK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:14 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/48] staging: comedi: amplc_dio200_common: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:19 +0100
Message-Id: <1410258417-28230-11-git-send-email-abbotti@mev.co.uk>
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
 .../staging/comedi/drivers/amplc_dio200_common.c   | 30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_dio200_common.c b/drivers/staging/comedi/drivers/amplc_dio200_common.c
index 6cadf7e..aed03dc 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200_common.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200_common.c
@@ -127,7 +127,7 @@ struct dio200_subdev_intr {
 static unsigned char dio200_read8(struct comedi_device *dev,
 				  unsigned int offset)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 
 	if (board->is_pcie)
 		offset <<= 3;
@@ -140,7 +140,7 @@ static unsigned char dio200_read8(struct comedi_device *dev,
 static void dio200_write8(struct comedi_device *dev,
 			  unsigned int offset, unsigned char val)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 
 	if (board->is_pcie)
 		offset <<= 3;
@@ -154,7 +154,7 @@ static void dio200_write8(struct comedi_device *dev,
 static unsigned int dio200_read32(struct comedi_device *dev,
 				  unsigned int offset)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 
 	if (board->is_pcie)
 		offset <<= 3;
@@ -167,7 +167,7 @@ static unsigned int dio200_read32(struct comedi_device *dev,
 static void dio200_write32(struct comedi_device *dev,
 			   unsigned int offset, unsigned int val)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 
 	if (board->is_pcie)
 		offset <<= 3;
@@ -183,7 +183,7 @@ static int dio200_subdev_intr_insn_bits(struct comedi_device *dev,
 					struct comedi_insn *insn,
 					unsigned int *data)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_intr *subpriv = s->private;
 
 	if (board->has_int_sce) {
@@ -200,7 +200,7 @@ static int dio200_subdev_intr_insn_bits(struct comedi_device *dev,
 static void dio200_stop_intr(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_intr *subpriv = s->private;
 
 	subpriv->active = false;
@@ -212,7 +212,7 @@ static void dio200_stop_intr(struct comedi_device *dev,
 static int dio200_start_intr(struct comedi_device *dev,
 			     struct comedi_subdevice *s)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_intr *subpriv = s->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int n;
@@ -306,7 +306,7 @@ static void dio200_read_scan_intr(struct comedi_device *dev,
 static int dio200_handle_read_intr(struct comedi_device *dev,
 				   struct comedi_subdevice *s)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_intr *subpriv = s->private;
 	unsigned triggered;
 	unsigned intstat;
@@ -481,7 +481,7 @@ static int dio200_subdev_intr_init(struct comedi_device *dev,
 				   unsigned int offset,
 				   unsigned valid_isns)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_intr *subpriv;
 
 	subpriv = comedi_alloc_spriv(s, sizeof(*subpriv));
@@ -626,7 +626,7 @@ static int dio200_subdev_8254_set_gate_src(struct comedi_device *dev,
 					   unsigned int counter_number,
 					   unsigned int gate_src)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_8254 *subpriv = s->private;
 	unsigned char byte;
 
@@ -648,7 +648,7 @@ static int dio200_subdev_8254_get_gate_src(struct comedi_device *dev,
 					   struct comedi_subdevice *s,
 					   unsigned int counter_number)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_8254 *subpriv = s->private;
 
 	if (!board->has_clk_gat_sce)
@@ -664,7 +664,7 @@ static int dio200_subdev_8254_set_clock_src(struct comedi_device *dev,
 					    unsigned int counter_number,
 					    unsigned int clock_src)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_8254 *subpriv = s->private;
 	unsigned char byte;
 
@@ -687,7 +687,7 @@ static int dio200_subdev_8254_get_clock_src(struct comedi_device *dev,
 					    unsigned int counter_number,
 					    unsigned int *period_ns)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_8254 *subpriv = s->private;
 	unsigned clock_src;
 
@@ -760,7 +760,7 @@ static int dio200_subdev_8254_init(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   unsigned int offset)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct dio200_subdev_8254 *subpriv;
 	unsigned int chan;
 
@@ -981,7 +981,7 @@ EXPORT_SYMBOL_GPL(amplc_dio200_set_enhance);
 int amplc_dio200_common_attach(struct comedi_device *dev, unsigned int irq,
 			       unsigned long req_irq_flags)
 {
-	const struct dio200_board *board = comedi_board(dev);
+	const struct dio200_board *board = dev->board_ptr;
 	struct comedi_subdevice *s;
 	unsigned int n;
 	int ret;
-- 
2.1.0

