Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaIIK1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:13 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36132 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbaIIK1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:10 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/48] staging: comedi: addi_apci_1516: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:12 +0100
Message-Id: <1410258417-28230-4-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/addi_apci_1516.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1516.c b/drivers/staging/comedi/drivers/addi_apci_1516.c
index 5cd3968..55d00fd 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1516.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1516.c
@@ -102,7 +102,7 @@ static int apci1516_do_insn_bits(struct comedi_device *dev,
 
 static int apci1516_reset(struct comedi_device *dev)
 {
-	const struct apci1516_boardinfo *this_board = comedi_board(dev);
+	const struct apci1516_boardinfo *this_board = dev->board_ptr;
 	struct apci1516_private *devpriv = dev->private;
 
 	if (!this_board->has_wdog)
-- 
2.1.0

