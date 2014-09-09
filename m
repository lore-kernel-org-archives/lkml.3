Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaIIK2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:28:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36297 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620AbaIIK1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:35 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 45/48] staging: comedi: pcmuio: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:54 +0100
Message-Id: <1410258417-28230-46-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcmuio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 1bca3fb..3aedeca 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -279,7 +279,7 @@ static int pcmuio_dio_insn_config(struct comedi_device *dev,
 
 static void pcmuio_reset(struct comedi_device *dev)
 {
-	const struct pcmuio_board *board = comedi_board(dev);
+	const struct pcmuio_board *board = dev->board_ptr;
 	int asic;
 
 	for (asic = 0; asic < board->num_asics; ++asic) {
@@ -587,7 +587,7 @@ static int pcmuio_cmdtest(struct comedi_device *dev,
 
 static int pcmuio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct pcmuio_board *board = comedi_board(dev);
+	const struct pcmuio_board *board = dev->board_ptr;
 	struct comedi_subdevice *s;
 	struct pcmuio_private *devpriv;
 	int ret;
-- 
2.1.0

