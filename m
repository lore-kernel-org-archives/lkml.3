Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaIIKaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:30:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36289 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbaIIK1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:32 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 39/48] staging: comedi: pcl726: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:48 +0100
Message-Id: <1410258417-28230-40-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcl726.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index 855c371..dc179bd 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -274,7 +274,7 @@ static int pcl726_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn,
 			       unsigned int *data)
 {
-	const struct pcl726_board *board = comedi_board(dev);
+	const struct pcl726_board *board = dev->board_ptr;
 	unsigned int val;
 
 	if (board->is_pcl727) {
@@ -295,7 +295,7 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn,
 			       unsigned int *data)
 {
-	const struct pcl726_board *board = comedi_board(dev);
+	const struct pcl726_board *board = dev->board_ptr;
 	unsigned long io = dev->iobase;
 	unsigned int mask;
 
@@ -322,7 +322,7 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 static int pcl726_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it)
 {
-	const struct pcl726_board *board = comedi_board(dev);
+	const struct pcl726_board *board = dev->board_ptr;
 	struct pcl726_private *devpriv;
 	struct comedi_subdevice *s;
 	int subdev;
-- 
2.1.0

