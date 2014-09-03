Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbaICMqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:21 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44695 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbaICMqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:18 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/37] staging: comedi: cb_pcidas64: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:36 +0100
Message-Id: <1409748360-17063-14-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/cb_pcidas64.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 34771c3..f1b2744 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1243,8 +1243,8 @@ static void enable_ai_interrupts(struct comedi_device *dev,
 	bits = EN_ADC_OVERRUN_BIT | EN_ADC_DONE_INTR_BIT |
 	       EN_ADC_ACTIVE_INTR_BIT | EN_ADC_STOP_INTR_BIT;
 	/*  Use pio transfer and interrupt on end of conversion
-	 *  if TRIG_WAKE_EOS flag is set. */
-	if (cmd->flags & TRIG_WAKE_EOS) {
+	 *  if CMDF_WAKE_EOS flag is set. */
+	if (cmd->flags & CMDF_WAKE_EOS) {
 		/*  4020 doesn't support pio transfers except for fifo dregs */
 		if (thisboard->layout != LAYOUT_4020)
 			bits |= ADC_INTR_EOSCAN_BITS | EN_ADC_INTR_SRC_BIT;
@@ -2579,7 +2579,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/*  clear adc buffer */
 	writew(0, devpriv->main_iobase + ADC_BUFFER_CLEAR_REG);
 
-	if ((cmd->flags & TRIG_WAKE_EOS) == 0 ||
+	if ((cmd->flags & CMDF_WAKE_EOS) == 0 ||
 	    thisboard->layout == LAYOUT_4020) {
 		devpriv->ai_dma_index = 0;
 
@@ -2613,7 +2613,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* enable pacing, triggering, etc */
 	bits = ADC_ENABLE_BIT | ADC_SOFT_GATE_BITS | ADC_GATE_LEVEL_BIT;
-	if (cmd->flags & TRIG_WAKE_EOS)
+	if (cmd->flags & CMDF_WAKE_EOS)
 		bits |= ADC_DMA_DISABLE_BIT;
 	/*  set start trigger */
 	if (cmd->start_src == TRIG_EXT) {
@@ -2820,7 +2820,7 @@ static void handle_ai_interrupt(struct comedi_device *dev,
 
 	/*  drain fifo with pio */
 	if ((status & ADC_DONE_BIT) ||
-	    ((cmd->flags & TRIG_WAKE_EOS) &&
+	    ((cmd->flags & CMDF_WAKE_EOS) &&
 	     (status & ADC_INTR_PENDING_BIT) &&
 	     (thisboard->layout != LAYOUT_4020))) {
 		spin_lock_irqsave(&dev->spinlock, flags);
-- 
2.1.0

