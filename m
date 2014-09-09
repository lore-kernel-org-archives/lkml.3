Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaIIKiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:38:51 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36171 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424AbaIIK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/48] staging: comedi: das1800: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:28 +0100
Message-Id: <1410258417-28230-20-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das1800.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index 9d0150d..a53d87c 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -453,7 +453,7 @@ static const struct comedi_lrange range_ao_2 = {
 static inline uint16_t munge_bipolar_sample(const struct comedi_device *dev,
 					    uint16_t sample)
 {
-	const struct das1800_board *thisboard = comedi_board(dev);
+	const struct das1800_board *thisboard = dev->board_ptr;
 
 	sample += 1 << (thisboard->resolution - 1);
 	return sample;
@@ -773,7 +773,7 @@ static int das1800_ai_do_cmdtest(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_cmd *cmd)
 {
-	const struct das1800_board *thisboard = comedi_board(dev);
+	const struct das1800_board *thisboard = dev->board_ptr;
 	struct das1800_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int arg;
@@ -1136,7 +1136,7 @@ static int das1800_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
-	const struct das1800_board *thisboard = comedi_board(dev);
+	const struct das1800_board *thisboard = dev->board_ptr;
 	int i, n;
 	int chan, range, aref, chan_range;
 	int timeout = 1000;
@@ -1200,7 +1200,7 @@ static int das1800_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
-	const struct das1800_board *thisboard = comedi_board(dev);
+	const struct das1800_board *thisboard = dev->board_ptr;
 	struct das1800_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 /* int range = CR_RANGE(insn->chanspec); */
@@ -1329,7 +1329,7 @@ static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
 
 static int das1800_probe(struct comedi_device *dev)
 {
-	const struct das1800_board *board = comedi_board(dev);
+	const struct das1800_board *board = dev->board_ptr;
 	int index;
 	int id;
 
@@ -1412,7 +1412,7 @@ static int das1800_attach(struct comedi_device *dev,
 	}
 
 	dev->board_ptr = das1800_boards + board;
-	thisboard = comedi_board(dev);
+	thisboard = dev->board_ptr;
 	dev->board_name = thisboard->name;
 
 	/*  if it is an 'ao' board with fancy analog out then we need extra io ports */
-- 
2.1.0

