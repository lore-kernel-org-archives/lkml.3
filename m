Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaIIKe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:34:58 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36161 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbaIIK1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 29/48] staging: comedi: ni_at_a2150: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:38 +0100
Message-Id: <1410258417-28230-30-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_at_a2150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index d490490..72ec857 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -287,7 +287,7 @@ static int a2150_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 			    unsigned int flags)
 {
-	const struct a2150_board *thisboard = comedi_board(dev);
+	const struct a2150_board *thisboard = dev->board_ptr;
 	struct a2150_private *devpriv = dev->private;
 	int lub, glb, temp;
 	int lub_divisor_shift, lub_index, glb_divisor_shift, glb_index;
@@ -436,7 +436,7 @@ static int a2150_ai_check_chanlist(struct comedi_device *dev,
 static int a2150_ai_cmdtest(struct comedi_device *dev,
 			    struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
-	const struct a2150_board *thisboard = comedi_board(dev);
+	const struct a2150_board *thisboard = dev->board_ptr;
 	int err = 0;
 	unsigned int arg;
 
@@ -710,7 +710,7 @@ static int a2150_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -ENODEV;
 
 	dev->board_ptr = a2150_boards + i;
-	thisboard = comedi_board(dev);
+	thisboard = dev->board_ptr;
 	dev->board_name = thisboard->name;
 
 	if ((irq >= 3 && irq <= 7) || (irq >= 9 && irq <= 12) ||
-- 
2.1.0

