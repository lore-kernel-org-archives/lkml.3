Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaIIKdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:33:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36162 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbaIIK10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:26 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 35/48] staging: comedi: ni_mio_common: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:44 +0100
Message-Id: <1410258417-28230-36-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_mio_common.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index b34df3a..320b080 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -1186,7 +1186,7 @@ static void ni_ao_fifo_load(struct comedi_device *dev,
 static int ni_ao_fifo_half_empty(struct comedi_device *dev,
 				 struct comedi_subdevice *s)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	int n;
 
 	n = comedi_buf_read_n_available(s);
@@ -1209,7 +1209,7 @@ static int ni_ao_fifo_half_empty(struct comedi_device *dev,
 static int ni_ao_prep_fifo(struct comedi_device *dev,
 			   struct comedi_subdevice *s)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	int n;
 
@@ -1296,7 +1296,7 @@ static void ni_ai_fifo_read(struct comedi_device *dev,
 
 static void ni_handle_fifo_half_full(struct comedi_device *dev)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct comedi_subdevice *s = dev->read_subdev;
 	int n;
 
@@ -1881,7 +1881,7 @@ static void ni_m_series_load_channelgain_list(struct comedi_device *dev,
 					      unsigned int n_chan,
 					      unsigned int *list)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	unsigned int chan, range, aref;
 	unsigned int i;
@@ -1988,7 +1988,7 @@ static void ni_load_channelgain_list(struct comedi_device *dev,
 				     struct comedi_subdevice *s,
 				     unsigned int n_chan, unsigned int *list)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	unsigned int offset = (s->maxdata + 1) >> 1;
 	unsigned int chan, range, aref;
@@ -2231,7 +2231,7 @@ static unsigned ni_timer_to_ns(const struct comedi_device *dev, int timer)
 static unsigned ni_min_ai_scan_period_ns(struct comedi_device *dev,
 					 unsigned num_channels)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 
 	/* simultaneously-sampled inputs */
@@ -2245,7 +2245,7 @@ static unsigned ni_min_ai_scan_period_ns(struct comedi_device *dev,
 static int ni_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_cmd *cmd)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int tmp;
@@ -2979,7 +2979,7 @@ static int ni_ao_insn_config(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 
 	switch (data[0]) {
@@ -3080,7 +3080,7 @@ static int ni_ao_inttrig(struct comedi_device *dev,
 
 static int ni_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	const struct comedi_cmd *cmd = &s->async->cmd;
 	int bits;
@@ -3281,7 +3281,7 @@ static int ni_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 static int ni_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 			 struct comedi_cmd *cmd)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int tmp;
@@ -4369,7 +4369,7 @@ static struct caldac_struct caldacs[] = {
 
 static void ni_write_caldac(struct comedi_device *dev, int addr, int val)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	unsigned int loadbit = 0, bits = 0, bit, bitstring = 0;
 	int i;
@@ -4427,7 +4427,7 @@ static int ni_calib_insn_read(struct comedi_device *dev,
 
 static void caldac_setup(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	int i, j;
 	int n_dacs;
@@ -5397,7 +5397,7 @@ static int ni_alloc_private(struct comedi_device *dev)
 static int ni_E_init(struct comedi_device *dev,
 		     unsigned interrupt_pin, unsigned irq_polarity)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	int ret;
-- 
2.1.0

