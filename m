Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbaIIKix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:38:53 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36163 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbaIIK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/48] staging: comedi: das16: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:27 +0100
Message-Id: <1410258417-28230-19-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das16.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index aa52a5b..baec9f2 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -631,7 +631,7 @@ static int das16_ai_check_chanlist(struct comedi_device *dev,
 static int das16_cmd_test(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_cmd *cmd)
 {
-	const struct das16_board *board = comedi_board(dev);
+	const struct das16_board *board = dev->board_ptr;
 	struct das16_private_struct *devpriv = dev->private;
 	int err = 0;
 	unsigned int trig_mask;
@@ -748,7 +748,7 @@ static unsigned int das16_set_pacer(struct comedi_device *dev, unsigned int ns,
 
 static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 {
-	const struct das16_board *board = comedi_board(dev);
+	const struct das16_board *board = dev->board_ptr;
 	struct das16_private_struct *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -883,7 +883,7 @@ static int das16_ai_insn_read(struct comedi_device *dev,
 			      struct comedi_insn *insn,
 			      unsigned int *data)
 {
-	const struct das16_board *board = comedi_board(dev);
+	const struct das16_board *board = dev->board_ptr;
 	unsigned int chan = CR_CHAN(insn->chanspec);
 	unsigned int range = CR_RANGE(insn->chanspec);
 	unsigned int val;
@@ -968,7 +968,7 @@ static int das16_do_insn_bits(struct comedi_device *dev,
 
 static int das16_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct das16_board *board = comedi_board(dev);
+	const struct das16_board *board = dev->board_ptr;
 	int diobits;
 
 	/* diobits indicates boards */
@@ -993,7 +993,7 @@ static void das16_reset(struct comedi_device *dev)
 
 static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct das16_board *board = comedi_board(dev);
+	const struct das16_board *board = dev->board_ptr;
 	struct das16_private_struct *devpriv;
 	struct comedi_subdevice *s;
 	struct comedi_lrange *lrange;
@@ -1219,7 +1219,7 @@ static int das16_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static void das16_detach(struct comedi_device *dev)
 {
-	const struct das16_board *board = comedi_board(dev);
+	const struct das16_board *board = dev->board_ptr;
 	struct das16_private_struct *devpriv = dev->private;
 	int i;
 
-- 
2.1.0

