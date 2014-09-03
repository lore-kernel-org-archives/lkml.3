Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbaICMya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:54:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44698 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaICMqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/37] staging: comedi: das1800: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:37 +0100
Message-Id: <1409748360-17063-15-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_WAKE_EOS` command flag with the new name
`CMDF_WAKE_EOS`.  The numeric value is unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/das1800.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index f9e4f72..951292d 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1088,14 +1088,14 @@ static int das1800_ai_do_cmd(struct comedi_device *dev,
 	struct comedi_async *async = s->async;
 	const struct comedi_cmd *cmd = &async->cmd;
 
-	/* disable dma on TRIG_WAKE_EOS, or CMDF_PRIORITY
+	/* disable dma on CMDF_WAKE_EOS, or CMDF_PRIORITY
 	 * (because dma in handler is unsafe at hard real-time priority) */
-	if (cmd->flags & (TRIG_WAKE_EOS | CMDF_PRIORITY))
+	if (cmd->flags & (CMDF_WAKE_EOS | CMDF_PRIORITY))
 		devpriv->irq_dma_bits &= ~DMA_ENABLED;
 	else
 		devpriv->irq_dma_bits |= devpriv->dma_bits;
-	/*  interrupt on end of conversion for TRIG_WAKE_EOS */
-	if (cmd->flags & TRIG_WAKE_EOS) {
+	/*  interrupt on end of conversion for CMDF_WAKE_EOS */
+	if (cmd->flags & CMDF_WAKE_EOS) {
 		/*  interrupt fifo not empty */
 		devpriv->irq_dma_bits &= ~FIMD;
 	} else {
-- 
2.1.0

