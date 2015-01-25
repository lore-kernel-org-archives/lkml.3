Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbbAYJay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 04:30:54 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37250 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbbAYJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 04:30:48 -0500
Date: Sun, 25 Jan 2015 17:30:42 +0800
From: Simon Guo <wei.guo.simon@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei.guo.simon@gmail.com
Subject: [PATCH 3.19.0-rc5 02/03] STAGING: Fix pcl818.c coding style issue:
 line over 80 characters
Message-ID: <20150125093042.GB4076@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
- line over 80 characters

Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 72a700c..0873617 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -304,9 +304,13 @@ static const struct pcl818_board boardtypes[] = {
 
 struct pcl818_private {
 	struct comedi_isadma *dma;
-	unsigned int ns_min;	/*  manimal allowed delay between samples (in us) for actual card */
+	unsigned int ns_min;	/*  manimal allowed delay between samples
+				 *  (in us) for actual card
+				 */
 	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
-	unsigned int act_chanlist[16];	/*  MUX setting for actual AI operations */
+	unsigned int act_chanlist[16];	/*  MUX setting for actual
+					 *  AI operations
+					 */
 	unsigned int act_chanlist_len;	/*  how long is actual MUX list */
 	unsigned int act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned int divisor1;
@@ -648,7 +652,8 @@ static int check_channel_list(struct comedi_device *dev,
 				break;
 			nowmustbechan =
 			    (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
-			if (nowmustbechan != CR_CHAN(chanlist[i])) {	/*  channel list isn't continuous :-( */
+			if (nowmustbechan != CR_CHAN(chanlist[i])) {
+				/*  channel list isn't continuous :-( */
 				dev_dbg(dev->class_dev,
 					"channel list must be continuous! chanlist[%i]=%d but must be %d or %d!\n",
 					i, CR_CHAN(chanlist[i]), nowmustbechan,
@@ -1154,8 +1159,9 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->ns_min = board->ns_min;
 
 	if (!board->is_818) {
+		/* extended PCL718 to 100kHz DAC */
 		if ((it->options[6] == 1) || (it->options[6] == 100))
-			devpriv->ns_min = 10000;	/* extended PCL718 to 100kHz DAC */
+			devpriv->ns_min = 10000;
 	}
 
 	pcl818_reset(dev);
-- 
1.8.1.2

