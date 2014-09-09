Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbaIIK20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:28:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36322 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbaIIK1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:41 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 48/48] staging: comedi: vmk80xx: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:57 +0100
Message-Id: <1410258417-28230-49-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/vmk80xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 831c3b7..7100341 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -767,7 +767,7 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
 
 static int vmk80xx_init_subdevices(struct comedi_device *dev)
 {
-	const struct vmk80xx_board *boardinfo = comedi_board(dev);
+	const struct vmk80xx_board *boardinfo = dev->board_ptr;
 	struct vmk80xx_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	int n_subd;
-- 
2.1.0

