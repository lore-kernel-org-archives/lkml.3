Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaIIKaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:30:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36301 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244AbaIIK1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:34 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 43/48] staging: comedi: pcl818: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:52 +0100
Message-Id: <1410258417-28230-44-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcl818.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 36c7751..ac19e83 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -738,7 +738,7 @@ static int check_single_ended(unsigned int port)
 static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 		      struct comedi_cmd *cmd)
 {
-	const struct pcl818_board *board = comedi_board(dev);
+	const struct pcl818_board *board = dev->board_ptr;
 	struct pcl818_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int arg;
@@ -980,7 +980,7 @@ static int pcl818_do_insn_bits(struct comedi_device *dev,
 
 static void pcl818_reset(struct comedi_device *dev)
 {
-	const struct pcl818_board *board = comedi_board(dev);
+	const struct pcl818_board *board = dev->board_ptr;
 	unsigned long timer_base = dev->iobase + PCL818_TIMER_BASE;
 	unsigned int chan;
 
@@ -1018,7 +1018,7 @@ static void pcl818_set_ai_range_table(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
 				      struct comedi_devconfig *it)
 {
-	const struct pcl818_board *board = comedi_board(dev);
+	const struct pcl818_board *board = dev->board_ptr;
 
 	/* default to the range table from the boardinfo */
 	s->range_table = board->ai_range_type;
@@ -1067,7 +1067,7 @@ static void pcl818_set_ai_range_table(struct comedi_device *dev,
 
 static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct pcl818_board *board = comedi_board(dev);
+	const struct pcl818_board *board = dev->board_ptr;
 	struct pcl818_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
-- 
2.1.0

