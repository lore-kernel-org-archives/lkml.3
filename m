Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbaICMte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:49:34 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44698 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736AbaICMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 26/37] staging: comedi: amplc_pci230: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:49 +0100
Message-Id: <1409748360-17063-27-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/amplc_pci230.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 6642744..eb75012 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -649,14 +649,14 @@ static unsigned int pci230_divide_ns(uint64_t ns, unsigned int timebase,
 
 	div = ns;
 	rem = do_div(div, timebase);
-	switch (flags & TRIG_ROUND_MASK) {
+	switch (flags & CMDF_ROUND_MASK) {
 	default:
-	case TRIG_ROUND_NEAREST:
+	case CMDF_ROUND_NEAREST:
 		div += (rem + (timebase / 2)) / timebase;
 		break;
-	case TRIG_ROUND_DOWN:
+	case CMDF_ROUND_DOWN:
 		break;
-	case TRIG_ROUND_UP:
+	case CMDF_ROUND_UP:
 		div += (rem + timebase - 1) / timebase;
 		break;
 	}
@@ -1735,7 +1735,7 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 		if (!pci230_ai_check_scan_period(cmd)) {
 			/* Was below minimum required.  Round up. */
 			pci230_ns_to_single_timer(&cmd->scan_begin_arg,
-						  TRIG_ROUND_UP);
+						  CMDF_ROUND_UP);
 			pci230_ai_check_scan_period(cmd);
 		}
 		if (tmp != cmd->scan_begin_arg)
@@ -2334,7 +2334,7 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			pci230_ct_setup_ns_mode(dev, 0, I8254_MODE1,
 						((uint64_t)cmd->convert_arg *
 						 cmd->scan_end_arg),
-						TRIG_ROUND_UP);
+						CMDF_ROUND_UP);
 			if (cmd->scan_begin_src == TRIG_TIMER) {
 				/*
 				 * Monostable on CT0 will be triggered by
-- 
2.1.0

