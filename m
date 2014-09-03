Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaICMsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:48:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44690 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbaICMq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:27 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 33/37] staging: comedi: ni_labpc_common: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:56 +0100
Message-Id: <1409748360-17063-34-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_labpc_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_common.c b/drivers/staging/comedi/drivers/ni_labpc_common.c
index 1881510..c54c88d 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_common.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_common.c
@@ -397,21 +397,21 @@ static void labpc_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd,
 		base_period = I8254_OSC_BASE_2MHZ * devpriv->divisor_b0;
 
 		/*  set a0 for conversion frequency and b1 for scan frequency */
-		switch (cmd->flags & TRIG_ROUND_MASK) {
+		switch (cmd->flags & CMDF_ROUND_MASK) {
 		default:
-		case TRIG_ROUND_NEAREST:
+		case CMDF_ROUND_NEAREST:
 			devpriv->divisor_a0 =
 			    (convert_period + (base_period / 2)) / base_period;
 			devpriv->divisor_b1 =
 			    (scan_period + (base_period / 2)) / base_period;
 			break;
-		case TRIG_ROUND_UP:
+		case CMDF_ROUND_UP:
 			devpriv->divisor_a0 =
 			    (convert_period + (base_period - 1)) / base_period;
 			devpriv->divisor_b1 =
 			    (scan_period + (base_period - 1)) / base_period;
 			break;
-		case TRIG_ROUND_DOWN:
+		case CMDF_ROUND_DOWN:
 			devpriv->divisor_a0 = convert_period / base_period;
 			devpriv->divisor_b1 = scan_period / base_period;
 			break;
-- 
2.1.0

