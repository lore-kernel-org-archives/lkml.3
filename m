Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaIIK1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:32 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36217 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451AbaIIK1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:20 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/48] staging: comedi: das800: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:30 +0100
Message-Id: <1410258417-28230-22-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das800.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index cbbb297..d75e552 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -248,7 +248,7 @@ static unsigned das800_ind_read(struct comedi_device *dev, unsigned reg)
 
 static void das800_enable(struct comedi_device *dev)
 {
-	const struct das800_board *thisboard = comedi_board(dev);
+	const struct das800_board *thisboard = dev->board_ptr;
 	struct das800_private *devpriv = dev->private;
 	unsigned long irq_flags;
 
@@ -325,7 +325,7 @@ static int das800_ai_do_cmdtest(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_cmd *cmd)
 {
-	const struct das800_board *thisboard = comedi_board(dev);
+	const struct das800_board *thisboard = dev->board_ptr;
 	struct das800_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int arg;
@@ -398,7 +398,7 @@ static int das800_ai_do_cmdtest(struct comedi_device *dev,
 static int das800_ai_do_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
-	const struct das800_board *thisboard = comedi_board(dev);
+	const struct das800_board *thisboard = dev->board_ptr;
 	struct das800_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
@@ -633,7 +633,7 @@ static int das800_do_insn_bits(struct comedi_device *dev,
 
 static int das800_probe(struct comedi_device *dev)
 {
-	const struct das800_board *thisboard = comedi_board(dev);
+	const struct das800_board *thisboard = dev->board_ptr;
 	int board = thisboard ? thisboard - das800_boards : -EINVAL;
 	int id_bits;
 	unsigned long irq_flags;
@@ -695,7 +695,7 @@ static int das800_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENODEV;
 	}
 	dev->board_ptr = das800_boards + board;
-	thisboard = comedi_board(dev);
+	thisboard = dev->board_ptr;
 	dev->board_name = thisboard->name;
 
 	if (irq > 1 && irq <= 7) {
-- 
2.1.0

