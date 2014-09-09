Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbaIIK1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:45 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36312 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625AbaIIK1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:37 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 41/48] staging: comedi: pcl812: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:50 +0100
Message-Id: <1410258417-28230-42-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcl812.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 61549e3..fd5ea6e 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -713,7 +713,7 @@ static int pcl812_ai_eoc(struct comedi_device *dev,
 static int pcl812_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
-	const struct pcl812_board *board = comedi_board(dev);
+	const struct pcl812_board *board = dev->board_ptr;
 	struct pcl812_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int flags;
@@ -1080,7 +1080,7 @@ static int pcl812_do_insn_bits(struct comedi_device *dev,
 
 static void pcl812_reset(struct comedi_device *dev)
 {
-	const struct pcl812_board *board = comedi_board(dev);
+	const struct pcl812_board *board = dev->board_ptr;
 	struct pcl812_private *devpriv = dev->private;
 	unsigned int chan;
 
@@ -1117,7 +1117,7 @@ static void pcl812_set_ai_range_table(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
 				      struct comedi_devconfig *it)
 {
-	const struct pcl812_board *board = comedi_board(dev);
+	const struct pcl812_board *board = dev->board_ptr;
 	struct pcl812_private *devpriv = dev->private;
 
 	/* default to the range table from the boardinfo */
@@ -1205,7 +1205,7 @@ static void pcl812_set_ai_range_table(struct comedi_device *dev,
 
 static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct pcl812_board *board = comedi_board(dev);
+	const struct pcl812_board *board = dev->board_ptr;
 	struct pcl812_private *devpriv;
 	struct comedi_subdevice *s;
 	int n_subdevices;
-- 
2.1.0

