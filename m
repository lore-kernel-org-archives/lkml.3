Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbaICMzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:55:45 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44679 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300AbaICMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/37] staging: comedi: adv_pci1710: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:33 +0100
Message-Id: <1409748360-17063-11-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/adv_pci1710.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 3e37b0b..b368962 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -907,7 +907,7 @@ static irqreturn_t interrupt_service_pci1710(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
-	if (cmd->flags & TRIG_WAKE_EOS)
+	if (cmd->flags & CMDF_WAKE_EOS)
 		pci1710_handle_every_sample(dev, s);
 	else
 		pci1710_handle_fifo(dev, s);
@@ -932,7 +932,7 @@ static int pci171x_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	s->async->cur_chan = 0;
 
 	devpriv->CntrlReg &= Control_CNT0;
-	if ((cmd->flags & TRIG_WAKE_EOS) == 0)
+	if ((cmd->flags & CMDF_WAKE_EOS) == 0)
 		devpriv->CntrlReg |= Control_ONEFH;
 
 	devpriv->divisor1 = devpriv->next_divisor1;
-- 
2.1.0

