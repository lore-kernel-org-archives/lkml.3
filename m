Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaIIKgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:36:37 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36167 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482AbaIIK1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/48] staging: comedi: ni_65xx: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:36 +0100
Message-Id: <1410258417-28230-28-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_65xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 63a33de..3b64286 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -294,7 +294,7 @@ MODULE_PARM_DESC(legacy_invert_outputs,
 
 static unsigned int ni_65xx_num_ports(struct comedi_device *dev)
 {
-	const struct ni_65xx_board *board = comedi_board(dev);
+	const struct ni_65xx_board *board = dev->board_ptr;
 
 	return board->num_dio_ports + board->num_di_ports + board->num_do_ports;
 }
-- 
2.1.0

