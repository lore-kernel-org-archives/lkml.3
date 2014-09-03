Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaICMrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:47:05 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44730 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbaICMq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:29 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 36/37] staging: comedi: rtd520: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:59 +0100
Message-Id: <1409748360-17063-37-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of the `TRIG_ROUND_...` macros with the new names
`CMDF_ROUND_...`.  The numeric values are unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/rtd520.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index cb02698e..2ea4a5c 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -399,15 +399,15 @@ static int rtd_ns_to_timer_base(unsigned int *nanosec,
 {
 	int divider;
 
-	switch (flags & TRIG_ROUND_MASK) {
-	case TRIG_ROUND_NEAREST:
+	switch (flags & CMDF_ROUND_MASK) {
+	case CMDF_ROUND_NEAREST:
 	default:
 		divider = (*nanosec + base / 2) / base;
 		break;
-	case TRIG_ROUND_DOWN:
+	case CMDF_ROUND_DOWN:
 		divider = (*nanosec) / base;
 		break;
-	case TRIG_ROUND_UP:
+	case CMDF_ROUND_UP:
 		divider = (*nanosec + base - 1) / base;
 		break;
 	}
@@ -808,26 +808,26 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 			if (cfc_check_trigger_arg_min(&cmd->scan_begin_arg,
 						      RTD_MAX_SPEED_1)) {
 				rtd_ns_to_timer(&cmd->scan_begin_arg,
-						TRIG_ROUND_UP);
+						CMDF_ROUND_UP);
 				err |= -EINVAL;
 			}
 			if (cfc_check_trigger_arg_max(&cmd->scan_begin_arg,
 						      RTD_MIN_SPEED_1)) {
 				rtd_ns_to_timer(&cmd->scan_begin_arg,
-						TRIG_ROUND_DOWN);
+						CMDF_ROUND_DOWN);
 				err |= -EINVAL;
 			}
 		} else {
 			if (cfc_check_trigger_arg_min(&cmd->scan_begin_arg,
 						      RTD_MAX_SPEED)) {
 				rtd_ns_to_timer(&cmd->scan_begin_arg,
-						TRIG_ROUND_UP);
+						CMDF_ROUND_UP);
 				err |= -EINVAL;
 			}
 			if (cfc_check_trigger_arg_max(&cmd->scan_begin_arg,
 						      RTD_MIN_SPEED)) {
 				rtd_ns_to_timer(&cmd->scan_begin_arg,
-						TRIG_ROUND_DOWN);
+						CMDF_ROUND_DOWN);
 				err |= -EINVAL;
 			}
 		}
@@ -843,26 +843,26 @@ static int rtd_ai_cmdtest(struct comedi_device *dev,
 			if (cfc_check_trigger_arg_min(&cmd->convert_arg,
 						      RTD_MAX_SPEED_1)) {
 				rtd_ns_to_timer(&cmd->convert_arg,
-						TRIG_ROUND_UP);
+						CMDF_ROUND_UP);
 				err |= -EINVAL;
 			}
 			if (cfc_check_trigger_arg_max(&cmd->convert_arg,
 						      RTD_MIN_SPEED_1)) {
 				rtd_ns_to_timer(&cmd->convert_arg,
-						TRIG_ROUND_DOWN);
+						CMDF_ROUND_DOWN);
 				err |= -EINVAL;
 			}
 		} else {
 			if (cfc_check_trigger_arg_min(&cmd->convert_arg,
 						      RTD_MAX_SPEED)) {
 				rtd_ns_to_timer(&cmd->convert_arg,
-						TRIG_ROUND_UP);
+						CMDF_ROUND_UP);
 				err |= -EINVAL;
 			}
 			if (cfc_check_trigger_arg_max(&cmd->convert_arg,
 						      RTD_MIN_SPEED)) {
 				rtd_ns_to_timer(&cmd->convert_arg,
-						TRIG_ROUND_DOWN);
+						CMDF_ROUND_DOWN);
 				err |= -EINVAL;
 			}
 		}
@@ -1019,7 +1019,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	switch (cmd->scan_begin_src) {
 	case TRIG_TIMER:	/* periodic scanning */
 		timer = rtd_ns_to_timer(&cmd->scan_begin_arg,
-					TRIG_ROUND_NEAREST);
+					CMDF_ROUND_NEAREST);
 		/* set PACER clock */
 		writel(timer & 0xffffff, dev->mmio + LAS0_PCLK);
 
@@ -1037,7 +1037,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		if (cmd->chanlist_len > 1) {
 			/* only needed for multi-channel */
 			timer = rtd_ns_to_timer(&cmd->convert_arg,
-						TRIG_ROUND_NEAREST);
+						CMDF_ROUND_NEAREST);
 			/* setup BURST clock */
 			writel(timer & 0x3ff, dev->mmio + LAS0_BCLK);
 		}
-- 
2.1.0

