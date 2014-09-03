Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaICMq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:28 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44730 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932692AbaICMq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:26 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 31/37] staging: comedi: me4000: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:54 +0100
Message-Id: <1409748360-17063-32-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/me4000.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 5b74b36..3b0df6b 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -650,10 +650,10 @@ static int ai_round_cmd_args(struct comedi_device *dev,
 		*init_ticks = (cmd->start_arg * 33) / 1000;
 		rest = (cmd->start_arg * 33) % 1000;
 
-		if ((cmd->flags & TRIG_ROUND_MASK) == TRIG_ROUND_NEAREST) {
+		if ((cmd->flags & CMDF_ROUND_MASK) == CMDF_ROUND_NEAREST) {
 			if (rest > 33)
 				(*init_ticks)++;
-		} else if ((cmd->flags & TRIG_ROUND_MASK) == TRIG_ROUND_UP) {
+		} else if ((cmd->flags & CMDF_ROUND_MASK) == CMDF_ROUND_UP) {
 			if (rest)
 				(*init_ticks)++;
 		}
@@ -663,10 +663,10 @@ static int ai_round_cmd_args(struct comedi_device *dev,
 		*scan_ticks = (cmd->scan_begin_arg * 33) / 1000;
 		rest = (cmd->scan_begin_arg * 33) % 1000;
 
-		if ((cmd->flags & TRIG_ROUND_MASK) == TRIG_ROUND_NEAREST) {
+		if ((cmd->flags & CMDF_ROUND_MASK) == CMDF_ROUND_NEAREST) {
 			if (rest > 33)
 				(*scan_ticks)++;
-		} else if ((cmd->flags & TRIG_ROUND_MASK) == TRIG_ROUND_UP) {
+		} else if ((cmd->flags & CMDF_ROUND_MASK) == CMDF_ROUND_UP) {
 			if (rest)
 				(*scan_ticks)++;
 		}
@@ -676,10 +676,10 @@ static int ai_round_cmd_args(struct comedi_device *dev,
 		*chan_ticks = (cmd->convert_arg * 33) / 1000;
 		rest = (cmd->convert_arg * 33) % 1000;
 
-		if ((cmd->flags & TRIG_ROUND_MASK) == TRIG_ROUND_NEAREST) {
+		if ((cmd->flags & CMDF_ROUND_MASK) == CMDF_ROUND_NEAREST) {
 			if (rest > 33)
 				(*chan_ticks)++;
-		} else if ((cmd->flags & TRIG_ROUND_MASK) == TRIG_ROUND_UP) {
+		} else if ((cmd->flags & CMDF_ROUND_MASK) == CMDF_ROUND_UP) {
 			if (rest)
 				(*chan_ticks)++;
 		}
@@ -849,7 +849,7 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	int err = 0;
 
 	/* Only rounding flags are implemented */
-	cmd->flags &= TRIG_ROUND_NEAREST | TRIG_ROUND_UP | TRIG_ROUND_DOWN;
+	cmd->flags &= CMDF_ROUND_NEAREST | CMDF_ROUND_UP | CMDF_ROUND_DOWN;
 
 	/* Round the timer arguments */
 	ai_round_cmd_args(dev, s, cmd, &init_ticks, &scan_ticks, &chan_ticks);
-- 
2.1.0

