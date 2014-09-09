Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbaIIK1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36167 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327AbaIIK1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:25 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 32/48] staging: comedi: ni_atmio: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:41 +0100
Message-Id: <1410258417-28230-33-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_atmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index 2bd9f69..0c5ff28 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -336,7 +336,7 @@ static int ni_atmio_attach(struct comedi_device *dev,
 		return -EIO;
 
 	dev->board_ptr = ni_boards + board;
-	boardtype = comedi_board(dev);
+	boardtype = dev->board_ptr;
 	dev->board_name = boardtype->name;
 
 	/* irq stuff */
-- 
2.1.0

