Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbaICM4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:56:52 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44679 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbaICMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/37] staging: comedi: ni_labpc_common: use CMDF_PRIORITY
Date: Wed,  3 Sep 2014 13:45:28 +0100
Message-Id: <1409748360-17063-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_RT` command flag with the equivalent flag
`CMDF_PRIORITY`.  The numeric value is unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_labpc_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_common.c b/drivers/staging/comedi/drivers/ni_labpc_common.c
index 9e76a36..5238a98 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_common.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_common.c
@@ -690,7 +690,7 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (labpc_have_dma_chan(dev) &&
 	    /* dma unsafe at RT priority,
 	     * and too much setup time for TRIG_WAKE_EOS */
-	    (cmd->flags & (TRIG_WAKE_EOS | TRIG_RT)) == 0)
+	    (cmd->flags & (TRIG_WAKE_EOS | CMDF_PRIORITY)) == 0)
 		xfer = isa_dma_transfer;
 	else if (/* pc-plus has no fifo-half full interrupt */
 		 board->is_labpc1200 &&
-- 
2.1.0

