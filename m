Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaIIKao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:30:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36297 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602AbaIIK1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 42/48] staging: comedi: pcl816: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:51 +0100
Message-Id: <1410258417-28230-43-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/pcl816.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index 54732c5..aa64871 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -671,7 +671,7 @@ static void pcl816_reset(struct comedi_device *dev)
 
 static int pcl816_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct pcl816_board *board = comedi_board(dev);
+	const struct pcl816_board *board = dev->board_ptr;
 	struct pcl816_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
-- 
2.1.0

