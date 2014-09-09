Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaIIK11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:27 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36171 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbaIIK1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:16 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/48] staging: comedi: cb_pcidas: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:24 +0100
Message-Id: <1410258417-28230-16-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/cb_pcidas.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index f5dd7dd..961903e 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -743,7 +743,7 @@ static int trimpot_8402_write(struct comedi_device *dev, unsigned int channel,
 static int cb_pcidas_trimpot_write(struct comedi_device *dev,
 				   unsigned int channel, unsigned int value)
 {
-	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	const struct cb_pcidas_board *thisboard = dev->board_ptr;
 	struct cb_pcidas_private *devpriv = dev->private;
 
 	if (devpriv->trimpot_value[channel] == value)
@@ -817,7 +817,7 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_cmd *cmd)
 {
-	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	const struct cb_pcidas_board *thisboard = dev->board_ptr;
 	struct cb_pcidas_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int arg;
@@ -939,7 +939,7 @@ static void cb_pcidas_ai_load_counters(struct comedi_device *dev)
 static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
-	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	const struct cb_pcidas_board *thisboard = dev->board_ptr;
 	struct cb_pcidas_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -1042,7 +1042,7 @@ static int cb_pcidas_ao_cmdtest(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_cmd *cmd)
 {
-	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	const struct cb_pcidas_board *thisboard = dev->board_ptr;
 	struct cb_pcidas_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int arg;
@@ -1134,7 +1134,7 @@ static int cb_pcidas_ao_inttrig(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				unsigned int trig_num)
 {
-	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	const struct cb_pcidas_board *thisboard = dev->board_ptr;
 	struct cb_pcidas_private *devpriv = dev->private;
 	unsigned int num_bytes, num_points = thisboard->fifo_size;
 	struct comedi_async *async = s->async;
@@ -1266,7 +1266,7 @@ static int cb_pcidas_ao_cancel(struct comedi_device *dev,
 
 static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status)
 {
-	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	const struct cb_pcidas_board *thisboard = dev->board_ptr;
 	struct cb_pcidas_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->write_subdev;
 	struct comedi_async *async = s->async;
@@ -1321,7 +1321,7 @@ static void handle_ao_interrupt(struct comedi_device *dev, unsigned int status)
 static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = (struct comedi_device *)d;
-	const struct cb_pcidas_board *thisboard = comedi_board(dev);
+	const struct cb_pcidas_board *thisboard = dev->board_ptr;
 	struct cb_pcidas_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct comedi_async *async;
-- 
2.1.0

