Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbaICMxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:53:45 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44679 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbaICMqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/37] staging: comedi: ni_labpc_common: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:38 +0100
Message-Id: <1409748360-17063-16-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_WAKE_EOS` command flag with the new name
`CMDF_WAKE_EOS`.  The numeric value is the same.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_labpc_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_common.c b/drivers/staging/comedi/drivers/ni_labpc_common.c
index 5238a98..1881510 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_common.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_common.c
@@ -689,13 +689,13 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* figure out what method we will use to transfer data */
 	if (labpc_have_dma_chan(dev) &&
 	    /* dma unsafe at RT priority,
-	     * and too much setup time for TRIG_WAKE_EOS */
-	    (cmd->flags & (TRIG_WAKE_EOS | CMDF_PRIORITY)) == 0)
+	     * and too much setup time for CMDF_WAKE_EOS */
+	    (cmd->flags & (CMDF_WAKE_EOS | CMDF_PRIORITY)) == 0)
 		xfer = isa_dma_transfer;
 	else if (/* pc-plus has no fifo-half full interrupt */
 		 board->is_labpc1200 &&
 		 /* wake-end-of-scan should interrupt on fifo not empty */
-		 (cmd->flags & TRIG_WAKE_EOS) == 0 &&
+		 (cmd->flags & CMDF_WAKE_EOS) == 0 &&
 		 /* make sure we are taking more than just a few points */
 		 (cmd->stop_src != TRIG_COUNT || devpriv->count > 256))
 		xfer = fifo_half_full_transfer;
-- 
2.1.0

