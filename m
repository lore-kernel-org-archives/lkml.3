Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaIIK1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36162 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbaIIK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:14 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/48] staging: comedi: amplc_pc236_common: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:20 +0100
Message-Id: <1410258417-28230-12-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/amplc_pc236_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pc236_common.c b/drivers/staging/comedi/drivers/amplc_pc236_common.c
index 2632a3b..963c5d8 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236_common.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236_common.c
@@ -29,7 +29,7 @@
 
 static void pc236_intr_update(struct comedi_device *dev, bool enable)
 {
-	const struct pc236_board *thisboard = comedi_board(dev);
+	const struct pc236_board *thisboard = dev->board_ptr;
 	struct pc236_private *devpriv = dev->private;
 	unsigned long flags;
 
@@ -49,7 +49,7 @@ static void pc236_intr_update(struct comedi_device *dev, bool enable)
  */
 static bool pc236_intr_check(struct comedi_device *dev)
 {
-	const struct pc236_board *thisboard = comedi_board(dev);
+	const struct pc236_board *thisboard = dev->board_ptr;
 	struct pc236_private *devpriv = dev->private;
 	bool retval = false;
 	unsigned long flags;
-- 
2.1.0

