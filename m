Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbaGWJlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:41:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35897 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588AbaGWJld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:41:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: comedi: ni_65xx: add ni_65xx_num_ports()
Date: Wed, 23 Jul 2014 10:41:18 +0100
Message-Id: <1406108481-23910-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
References: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to return the total number of digital I/O, digital input,
and digital output ports on the board.  Each port has 8 channels (bits).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index aba6fbb..0f9185e 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -296,17 +296,19 @@ struct ni_65xx_private {
 	void __iomem *mmio;
 };
 
-static void ni_65xx_disable_input_filters(struct comedi_device *dev)
+static unsigned int ni_65xx_num_ports(struct comedi_device *dev)
 {
 	const struct ni_65xx_board *board = comedi_board(dev);
+
+	return board->num_dio_ports + board->num_di_ports + board->num_do_ports;
+}
+
+static void ni_65xx_disable_input_filters(struct comedi_device *dev)
+{
 	struct ni_65xx_private *devpriv = dev->private;
-	unsigned num_ports;
+	unsigned int num_ports = ni_65xx_num_ports(dev);
 	int i;
 
-	num_ports = board->num_dio_ports +
-		    board->num_di_ports +
-		    board->num_do_ports;
-
 	/* disable input filtering on all ports */
 	for (i = 0; i < num_ports; ++i)
 		writeb(0x00, devpriv->mmio + NI_65XX_FILTER_ENA(i));
-- 
2.0.0

