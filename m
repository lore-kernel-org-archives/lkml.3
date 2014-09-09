Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbaIIKiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:38:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36161 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbaIIK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/48] staging: comedi: das08: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:25 +0100
Message-Id: <1410258417-28230-17-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das08.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index f761a5a..bdb671a 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -217,7 +217,7 @@ static int das08_ai_eoc(struct comedi_device *dev,
 static int das08_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	struct das08_private_struct *devpriv = dev->private;
 	int n;
 	int chan;
@@ -337,7 +337,7 @@ static int das08jr_do_wbits(struct comedi_device *dev,
 static void das08_ao_set_data(struct comedi_device *dev,
 			      unsigned int chan, unsigned int data)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	unsigned char lsb;
 	unsigned char msb;
 
@@ -376,7 +376,7 @@ static int das08_ao_insn_write(struct comedi_device *dev,
 
 static void i8254_initialize(struct comedi_device *dev)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	unsigned long i8254_iobase = dev->iobase + thisboard->i8254_offset;
 	unsigned int mode = I8254_MODE0 | I8254_BINARY;
 	int i;
@@ -389,7 +389,7 @@ static int das08_counter_read(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	unsigned long i8254_iobase = dev->iobase + thisboard->i8254_offset;
 	int chan = insn->chanspec;
 
@@ -401,7 +401,7 @@ static int das08_counter_write(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	unsigned long i8254_iobase = dev->iobase + thisboard->i8254_offset;
 	int chan = insn->chanspec;
 
@@ -413,7 +413,7 @@ static int das08_counter_config(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	unsigned long i8254_iobase = dev->iobase + thisboard->i8254_offset;
 	int chan = insn->chanspec;
 
@@ -432,7 +432,7 @@ static int das08_counter_config(struct comedi_device *dev,
 
 int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	struct das08_private_struct *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	int ret;
-- 
2.1.0

