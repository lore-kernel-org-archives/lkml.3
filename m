Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaIIKez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:34:55 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36162 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbaIIK1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/48] staging: comedi: ni_660x: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:37 +0100
Message-Id: <1410258417-28230-29-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_660x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index b0b03d4..5b6794c 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -433,7 +433,7 @@ struct ni_660x_private {
 
 static inline unsigned ni_660x_num_counters(struct comedi_device *dev)
 {
-	const struct ni_660x_board *board = comedi_board(dev);
+	const struct ni_660x_board *board = dev->board_ptr;
 
 	return board->n_chips * counters_per_chip;
 }
@@ -852,7 +852,7 @@ static int ni_660x_allocate_private(struct comedi_device *dev)
 
 static int ni_660x_alloc_mite_rings(struct comedi_device *dev)
 {
-	const struct ni_660x_board *board = comedi_board(dev);
+	const struct ni_660x_board *board = dev->board_ptr;
 	struct ni_660x_private *devpriv = dev->private;
 	unsigned i;
 	unsigned j;
@@ -870,7 +870,7 @@ static int ni_660x_alloc_mite_rings(struct comedi_device *dev)
 
 static void ni_660x_free_mite_rings(struct comedi_device *dev)
 {
-	const struct ni_660x_board *board = comedi_board(dev);
+	const struct ni_660x_board *board = dev->board_ptr;
 	struct ni_660x_private *devpriv = dev->private;
 	unsigned i;
 	unsigned j;
@@ -924,7 +924,7 @@ static void ni_660x_select_pfi_output(struct comedi_device *dev,
 				      unsigned pfi_channel,
 				      unsigned output_select)
 {
-	const struct ni_660x_board *board = comedi_board(dev);
+	const struct ni_660x_board *board = dev->board_ptr;
 	static const unsigned counter_4_7_first_pfi = 8;
 	static const unsigned counter_4_7_last_pfi = 23;
 	unsigned active_chipset = 0;
-- 
2.1.0

