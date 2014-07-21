Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaGUQ3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:29:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59339 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbaGUQ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:29:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: comedi: ni_6527: reset edge detection registers
Date: Mon, 21 Jul 2014 17:29:06 +0100
Message-Id: <1405960146-8959-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405960146-8959-1-git-send-email-abbotti@mev.co.uk>
References: <1405960146-8959-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`ni6527_reset()` is called to reset various registers when the device is
being initialized or deinitialized.  The edge detection interrupt is
disabled by this function, but the rising and falling edge detection
registers are currently left alone.  Call `ni6527_set_edge_detection()`
to set them to a known, disabled state.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_6527.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index 57d8d4c..8ea93b5 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -393,6 +393,9 @@ static void ni6527_reset(struct comedi_device *dev)
 	/* disable deglitch filters on all channels */
 	ni6527_set_filter_enable(dev, 0);
 
+	/* disable edge detection */
+	ni6527_set_edge_detection(dev, 0xffffffff, 0, 0);
+
 	writeb(NI6527_CLR_IRQS | NI6527_CLR_RESET_FILT,
 	       mmio + NI6527_CLR_REG);
 	writeb(NI6527_CTRL_DISABLE_IRQS, mmio + NI6527_CTRL_REG);
-- 
2.0.0

