Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaICMqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44690 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792AbaICMq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:29 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 34/37] staging: comedi: ni_mio_common: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:57 +0100
Message-Id: <1409748360-17063-35-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_mio_common.c | 38 +++++++++++++-------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 584de17..b34df3a 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -2206,15 +2206,15 @@ static int ni_ns_to_timer(const struct comedi_device *dev, unsigned nanosec,
 	struct ni_private *devpriv = dev->private;
 	int divider;
 
-	switch (flags & TRIG_ROUND_MASK) {
-	case TRIG_ROUND_NEAREST:
+	switch (flags & CMDF_ROUND_MASK) {
+	case CMDF_ROUND_NEAREST:
 	default:
 		divider = (nanosec + devpriv->clock_ns / 2) / devpriv->clock_ns;
 		break;
-	case TRIG_ROUND_DOWN:
+	case CMDF_ROUND_DOWN:
 		divider = (nanosec) / devpriv->clock_ns;
 		break;
-	case TRIG_ROUND_UP:
+	case CMDF_ROUND_UP:
 		divider = (nanosec + devpriv->clock_ns - 1) / devpriv->clock_ns;
 		break;
 	}
@@ -2541,7 +2541,7 @@ static int ni_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 		/* load SI */
 		timer = ni_ns_to_timer(dev, cmd->scan_begin_arg,
-				       TRIG_ROUND_NEAREST);
+				       CMDF_ROUND_NEAREST);
 		ni_stc_writel(dev, timer, AI_SI_Load_A_Registers);
 		ni_stc_writew(dev, AI_SI_Load, AI_Command_1_Register);
 		break;
@@ -2569,7 +2569,7 @@ static int ni_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			timer = 1;
 		else
 			timer = ni_ns_to_timer(dev, cmd->convert_arg,
-					       TRIG_ROUND_NEAREST);
+					       CMDF_ROUND_NEAREST);
 		/* 0,0 does not work */
 		ni_stc_writew(dev, 1, AI_SI2_Load_A_Register);
 		ni_stc_writew(dev, timer, AI_SI2_Load_B_Register);
@@ -3190,7 +3190,7 @@ static int ni_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->ao_cmd2 &= ~AO_BC_Gate_Enable;
 		trigvar =
 		    ni_ns_to_timer(dev, cmd->scan_begin_arg,
-				   TRIG_ROUND_NEAREST);
+				   CMDF_ROUND_NEAREST);
 		ni_stc_writel(dev, 1, AO_UI_Load_A_Register);
 		ni_stc_writew(dev, AO_UI_Load, AO_Command_1_Register);
 		ni_stc_writel(dev, trigvar, AO_UI_Load_A_Register);
@@ -4187,15 +4187,15 @@ static int ni_m_series_pwm_config(struct comedi_device *dev,
 	switch (data[0]) {
 	case INSN_CONFIG_PWM_OUTPUT:
 		switch (data[1]) {
-		case TRIG_ROUND_NEAREST:
+		case CMDF_ROUND_NEAREST:
 			up_count =
 			    (data[2] +
 			     devpriv->clock_ns / 2) / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_DOWN:
+		case CMDF_ROUND_DOWN:
 			up_count = data[2] / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_UP:
+		case CMDF_ROUND_UP:
 			up_count =
 			    (data[2] + devpriv->clock_ns -
 			     1) / devpriv->clock_ns;
@@ -4204,15 +4204,15 @@ static int ni_m_series_pwm_config(struct comedi_device *dev,
 			return -EINVAL;
 		}
 		switch (data[3]) {
-		case TRIG_ROUND_NEAREST:
+		case CMDF_ROUND_NEAREST:
 			down_count =
 			    (data[4] +
 			     devpriv->clock_ns / 2) / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_DOWN:
+		case CMDF_ROUND_DOWN:
 			down_count = data[4] / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_UP:
+		case CMDF_ROUND_UP:
 			down_count =
 			    (data[4] + devpriv->clock_ns -
 			     1) / devpriv->clock_ns;
@@ -4251,15 +4251,15 @@ static int ni_6143_pwm_config(struct comedi_device *dev,
 	switch (data[0]) {
 	case INSN_CONFIG_PWM_OUTPUT:
 		switch (data[1]) {
-		case TRIG_ROUND_NEAREST:
+		case CMDF_ROUND_NEAREST:
 			up_count =
 			    (data[2] +
 			     devpriv->clock_ns / 2) / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_DOWN:
+		case CMDF_ROUND_DOWN:
 			up_count = data[2] / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_UP:
+		case CMDF_ROUND_UP:
 			up_count =
 			    (data[2] + devpriv->clock_ns -
 			     1) / devpriv->clock_ns;
@@ -4268,15 +4268,15 @@ static int ni_6143_pwm_config(struct comedi_device *dev,
 			return -EINVAL;
 		}
 		switch (data[3]) {
-		case TRIG_ROUND_NEAREST:
+		case CMDF_ROUND_NEAREST:
 			down_count =
 			    (data[4] +
 			     devpriv->clock_ns / 2) / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_DOWN:
+		case CMDF_ROUND_DOWN:
 			down_count = data[4] / devpriv->clock_ns;
 			break;
-		case TRIG_ROUND_UP:
+		case CMDF_ROUND_UP:
 			down_count =
 			    (data[4] + devpriv->clock_ns -
 			     1) / devpriv->clock_ns;
-- 
2.1.0

