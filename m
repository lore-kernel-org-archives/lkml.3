Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbaICMyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:54:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44690 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbaICMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/37] staging: comedi: cb_pcidas: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:35 +0100
Message-Id: <1409748360-17063-13-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/cb_pcidas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index a0bb4c8..f5dd7dd 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -981,7 +981,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->adc_fifo_bits |= INTE;
 	devpriv->adc_fifo_bits &= ~INT_MASK;
-	if (cmd->flags & TRIG_WAKE_EOS) {
+	if (cmd->flags & CMDF_WAKE_EOS) {
 		if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1) {
 			/* interrupt end of burst */
 			devpriv->adc_fifo_bits |= INT_EOS;
-- 
2.1.0

