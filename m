Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbaICMzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:55:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44698 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbaICMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/37] staging: comedi: adl_pci9118: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:32 +0100
Message-Id: <1409748360-17063-10-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_WAKE_EOS` command flag with the new name
`CMDF_WAKE_EOS`.  The numeric value is unchanged.  Also change
diagnostic messages to use "CMDF_WAKE_EOS" instead of "TRIG_WAKE_EOS"
and change the Comedi driver description comment to use "CMDF_WAKE_EOS".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 6fc50b3..3e16b5f 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -36,8 +36,8 @@
  * b) DMA transfers must have the length aligned to two samples (32 bit),
  *  so there is some problems if cmd->chanlist_len is odd. This driver tries
  *  bypass this with adding one sample to the end of the every scan and discard
- *  it on output but this cann't be used if cmd->scan_begin_src=TRIG_FOLLOW
- *  and is used flag TRIG_WAKE_EOS, then driver switch to interrupt driven mode
+ *  it on output but this can't be used if cmd->scan_begin_src=TRIG_FOLLOW
+ *  and is used flag CMDF_WAKE_EOS, then driver switch to interrupt driven mode
  *  with interrupt after every sample.
  * c) If isn't used DMA then you can use only mode where
  *  cmd->scan_begin_src=TRIG_FOLLOW.
@@ -1294,12 +1294,12 @@ static int Compute_and_setup_dma(struct comedi_device *dev,
 	}
 
 	/* we want wake up every scan? */
-	if (devpriv->ai_flags & TRIG_WAKE_EOS) {
+	if (devpriv->ai_flags & CMDF_WAKE_EOS) {
 		if (dmalen0 < (devpriv->ai_n_realscanlen << 1)) {
 			/* uff, too short DMA buffer, disable EOS support! */
-			devpriv->ai_flags &= (~TRIG_WAKE_EOS);
+			devpriv->ai_flags &= (~CMDF_WAKE_EOS);
 			dev_info(dev->class_dev,
-				 "WAR: DMA0 buf too short, can't support TRIG_WAKE_EOS (%d<%d)\n",
+				 "WAR: DMA0 buf too short, can't support CMDF_WAKE_EOS (%d<%d)\n",
 				  dmalen0, devpriv->ai_n_realscanlen << 1);
 		} else {
 			/* short first DMA buffer to one scan */
@@ -1312,12 +1312,12 @@ static int Compute_and_setup_dma(struct comedi_device *dev,
 			}
 		}
 	}
-	if (devpriv->ai_flags & TRIG_WAKE_EOS) {
+	if (devpriv->ai_flags & CMDF_WAKE_EOS) {
 		if (dmalen1 < (devpriv->ai_n_realscanlen << 1)) {
 			/* uff, too short DMA buffer, disable EOS support! */
-			devpriv->ai_flags &= (~TRIG_WAKE_EOS);
+			devpriv->ai_flags &= (~CMDF_WAKE_EOS);
 			dev_info(dev->class_dev,
-				 "WAR: DMA1 buf too short, can't support TRIG_WAKE_EOS (%d<%d)\n",
+				 "WAR: DMA1 buf too short, can't support CMDF_WAKE_EOS (%d<%d)\n",
 				 dmalen1, devpriv->ai_n_realscanlen << 1);
 		} else {
 			/* short second DMA buffer to one scan */
@@ -1331,8 +1331,8 @@ static int Compute_and_setup_dma(struct comedi_device *dev,
 		}
 	}
 
-	/* transfer without TRIG_WAKE_EOS */
-	if (!(devpriv->ai_flags & TRIG_WAKE_EOS)) {
+	/* transfer without CMDF_WAKE_EOS */
+	if (!(devpriv->ai_flags & CMDF_WAKE_EOS)) {
 		/* if it's possible then align DMA buffers to length of scan */
 		i = dmalen0;
 		dmalen0 =
@@ -1570,7 +1570,7 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	devpriv->ai_add_back = 0;
 	if (devpriv->master) {
 		devpriv->usedma = 1;
-		if ((cmd->flags & TRIG_WAKE_EOS) &&
+		if ((cmd->flags & CMDF_WAKE_EOS) &&
 		    (cmd->scan_end_arg == 1)) {
 			if (cmd->convert_src == TRIG_NOW)
 				devpriv->ai_add_back = 1;
@@ -1582,7 +1582,7 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 					 */
 			}
 		}
-		if ((cmd->flags & TRIG_WAKE_EOS) &&
+		if ((cmd->flags & CMDF_WAKE_EOS) &&
 		    (cmd->scan_end_arg & 1) &&
 		    (cmd->scan_end_arg > 1)) {
 			if (cmd->scan_begin_src == TRIG_FOLLOW) {
-- 
2.1.0

