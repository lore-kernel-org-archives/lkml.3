Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbaIIKm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:42:56 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36162 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbaIIK1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:12 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/48] staging: comedi: addi_apci_3xxx: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:14 +0100
Message-Id: <1410258417-28230-6-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/addi_apci_3xxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
index f26e4ec..a296bd5 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
@@ -472,7 +472,7 @@ static int apci3xxx_ai_insn_read(struct comedi_device *dev,
 static int apci3xxx_ai_ns_to_timer(struct comedi_device *dev,
 				   unsigned int *ns, unsigned int flags)
 {
-	const struct apci3xxx_boardinfo *board = comedi_board(dev);
+	const struct apci3xxx_boardinfo *board = dev->board_ptr;
 	struct apci3xxx_private *devpriv = dev->private;
 	unsigned int base;
 	unsigned int timer;
@@ -523,7 +523,7 @@ static int apci3xxx_ai_cmdtest(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_cmd *cmd)
 {
-	const struct apci3xxx_boardinfo *board = comedi_board(dev);
+	const struct apci3xxx_boardinfo *board = dev->board_ptr;
 	int err = 0;
 	unsigned int arg;
 
-- 
2.1.0

