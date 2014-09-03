Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbaICMqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44695 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598AbaICMqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:16 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/37] staging: comedi: addi_apci_3120: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:31 +0100
Message-Id: <1409748360-17063-9-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 77cee87..87dff80 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1114,7 +1114,7 @@ static int apci3120_cyclic_ai(int mode,
 					  dmalen0;
 		}
 
-		if (cmd->flags & TRIG_WAKE_EOS) {
+		if (cmd->flags & CMDF_WAKE_EOS) {
 			/*  don't we want wake up every scan? */
 			if (dmalen0 > scan_bytes) {
 				dmalen0 = scan_bytes;
@@ -1433,7 +1433,7 @@ static void apci3120_interrupt_dma(int irq, void *d)
 			devpriv->ul_DmaBufferVirtual[devpriv->
 				ui_DmaActualBuffer], samplesinbuf);
 
-		if (!(cmd->flags & TRIG_WAKE_EOS)) {
+		if (!(cmd->flags & CMDF_WAKE_EOS)) {
 			s->async->events |= COMEDI_CB_EOS;
 			comedi_event(dev, s);
 		}
-- 
2.1.0

