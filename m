Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbaGODSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:18:09 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:43510 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaGODSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:18:06 -0400
From: sam-the-6 <asadi.samuel@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 93/93] Staging: comedi: adl_pci9118: fixed style issues
Date: Tue, 15 Jul 2014 06:17:59 +0300
Message-Id: <1405394279-26061-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Asadi <asadi.samuel@gmail.com>

several style issues fixed.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>

	modified:   drivers/staging/comedi/drivers/adl_pci9118.c
---
 drivers/staging/comedi/drivers/adl_pci9118.c |  124 +++++++++++++-------------
 1 file changed, 62 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 59a65cb..7139f87 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -8,59 +8,63 @@
  * Author: Michal Dobes <dobes@tesnet.cz>
  *
 */
-/*
-Driver: adl_pci9118
-Description: Adlink PCI-9118DG, PCI-9118HG, PCI-9118HR
-Author: Michal Dobes <dobes@tesnet.cz>
-Devices: [ADLink] PCI-9118DG (pci9118dg), PCI-9118HG (pci9118hg),
-  PCI-9118HR (pci9118hr)
-Status: works
-
-This driver supports AI, AO, DI and DO subdevices.
-AI subdevice supports cmd and insn interface,
-other subdevices support only insn interface.
-For AI:
-- If cmd->scan_begin_src=TRIG_EXT then trigger input is TGIN (pin 46).
-- If cmd->convert_src=TRIG_EXT then trigger input is EXTTRG (pin 44).
-- If cmd->start_src/stop_src=TRIG_EXT then trigger input is TGIN (pin 46).
-- It is not necessary to have cmd.scan_end_arg=cmd.chanlist_len but
-  cmd.scan_end_arg modulo cmd.chanlist_len must by 0.
-- If return value of cmdtest is 5 then you've bad channel list
-  (it isn't possible mixture S.E. and DIFF inputs or bipolar and unipolar
-  ranges).
-
-There are some hardware limitations:
-a) You cann't use mixture of unipolar/bipoar ranges or differencial/single
-   ended inputs.
-b) DMA transfers must have the length aligned to two samples (32 bit),
-   so there is some problems if cmd->chanlist_len is odd. This driver tries
-   bypass this with adding one sample to the end of the every scan and discard
-   it on output but this cann't be used if cmd->scan_begin_src=TRIG_FOLLOW
-   and is used flag TRIG_WAKE_EOS, then driver switch to interrupt driven mode
-   with interrupt after every sample.
-c) If isn't used DMA then you can use only mode where
-   cmd->scan_begin_src=TRIG_FOLLOW.
-
-Configuration options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-	If bus/slot is not specified, then first available PCI
-	card will be used.
-  [2] - 0= standard 8 DIFF/16 SE channels configuration
-	n = external multiplexer connected, 1 <= n <= 256
-  [3] - 0=autoselect DMA or EOC interrupts operation
-	1 = disable DMA mode
-	3 = disable DMA and INT, only insn interface will work
-  [4] - sample&hold signal - card can generate signal for external S&H board
-	0 = use SSHO(pin 45) signal is generated in onboard hardware S&H logic
-	0 != use ADCHN7(pin 23) signal is generated from driver, number say how
-		long delay is requested in ns and sign polarity of the hold
-		(in this case external multiplexor can serve only 128 channels)
-  [5] - 0=stop measure on all hardware errors
-	2 | = ignore ADOR - A/D Overrun status
-	8|=ignore Bover - A/D Burst Mode Overrun status
-	256|=ignore nFull - A/D FIFO Full status
 
+/*
+     Driver: adl_pci9118
+     Description: Adlink PCI-9118DG, PCI-9118HG, PCI-9118HR
+     Author: Michal Dobes <dobes@tesnet.cz>
+     Devices: [ADLink] PCI-9118DG (pci9118dg), PCI-9118HG (pci9118hg),
+     PCI-9118HR (pci9118hr)
+     Status: works
+
+     This driver supports AI, AO, DI and DO subdevices.
+     AI subdevice supports cmd and insn interface,
+     other subdevices support only insn interface.
+     For AI:
+     - If cmd->scan_begin_src=TRIG_EXT then trigger input is TGIN (pin 46).
+     - If cmd->convert_src=TRIG_EXT then trigger input is EXTTRG (pin 44).
+     - If cmd->start_src/stop_src=TRIG_EXT then trigger input is TGIN (pin 46).
+     - It is not necessary to have cmd.scan_end_arg=cmd.chanlist_len but
+       cmd.scan_end_arg modulo cmd.chanlist_len must by 0.
+     - If return value of cmdtest is 5 then you've bad channel list
+       (it isn't possible mixture S.E. and DIFF inputs or bipolar and unipolar
+       ranges).
+
+     There are some hardware limitations:
+     a) You cann't use mixture of unipolar/bipoar ranges or differencial/single
+	ended inputs.
+     b) DMA transfers must have the length aligned to two samples (32 bit),
+	so there is some problems if cmd->chanlist_len is odd. This driver
+	tries bypass this with adding one sample to the end of the every scan
+	and discard it on output but this cann't be used if
+	cmd->scan_begin_src=TRIG_FOLLOW and is used flag TRIG_WAKE_EOS, then
+	driver switch to interrupt driven mode with interrupt after every
+	sample.
+     c) If isn't used DMA then you can use only mode where
+	cmd->scan_begin_src=TRIG_FOLLOW.
+
+     Configuration options:
+       [0] - PCI bus of device (optional)
+       [1] - PCI slot of device (optional)
+	     If bus/slot is not specified, then first available PCI
+	     card will be used.
+       [2] - 0= standard 8 DIFF/16 SE channels configuration
+	     n = external multiplexer connected, 1 <= n <= 256
+       [3] - 0=autoselect DMA or EOC interrupts operation
+	     1 = disable DMA mode
+	     3 = disable DMA and INT, only insn interface will work
+       [4] - sample&hold signal - card can generate signal for external
+	     S&H board
+	     0 = use SSHO(pin 45) signal is generated in onboard hardware
+		 S&H logic
+	     0 != use ADCHN7(pin 23) signal is generated from driver, number
+		  say how long delay is requested in ns and sign polarity of
+		  the hold (in this case external multiplexor can serve only
+		  128 channels)
+       [5] - 0=stop measure on all hardware errors
+	     2 | = ignore ADOR - A/D Overrun status
+	     8|=ignore Bover - A/D Burst Mode Overrun status
+	     256|=ignore nFull - A/D FIFO Full status
 */
 
 /*
@@ -346,7 +350,7 @@ struct pci9118_private {
 						 * on external start
 						 */
 	unsigned short ao_data[2];		/* data output buffer */
-	char dma_doublebuf;			/* we can use double buffering */
+	char dma_doublebuf;		/* we can use double buffering */
 	unsigned int dma_actbuf;		/* which buffer is used now */
 	unsigned short *dmabuf_virt[2];		/*
 						 * pointers to begin of
@@ -399,7 +403,7 @@ static int check_channel_list(struct comedi_device *dev,
 	}
 	if ((frontadd + n_chan + backadd) > s->len_chanlist) {
 		comedi_error(dev,
-			    "range/channel list is too long for actual configuration!\n");
+		"range/channel list is too long for actual configuration!\n");
 		return 0;
 	}
 
@@ -412,22 +416,19 @@ static int check_channel_list(struct comedi_device *dev,
 			if ((CR_AREF(chanlist[i]) == AREF_DIFF) !=
 			    (differencial)) {
 				comedi_error(dev,
-					     "Differencial and single ended "
-						"inputs can't be mixtured!");
+						"Differencial and single ended inputs can't be mixtured!");
 				return 0;
 			}
 			if ((CR_RANGE(chanlist[i]) < PCI9118_BIPOLAR_RANGES) !=
 			    (bipolar)) {
 				comedi_error(dev,
-					     "Bipolar and unipolar ranges "
-							"can't be mixtured!");
+						"Bipolar and unipolar ranges can't be mixtured!");
 				return 0;
 			}
 			if (!devpriv->usemux && differencial &&
 			    (CR_CHAN(chanlist[i]) >= this_board->n_aichand)) {
 				comedi_error(dev,
-					     "If AREF_DIFF is used then is "
-					"available only first 8 channels!");
+						"If AREF_DIFF is used then is available only first 8 channels!");
 				return 0;
 			}
 		}
@@ -1678,8 +1679,7 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 						/* double timed action */
 		if (!devpriv->usedma) {
 			comedi_error(dev,
-				     "cmd->scan_begin_src=TRIG_TIMER works "
-						"only with bus mastering!");
+					"cmd->scan_begin_src=TRIG_TIMER works only with bus mastering!");
 			return -EIO;
 		}
 
-- 
1.7.10.4

