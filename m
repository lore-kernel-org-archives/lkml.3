Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbaICM4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:56:22 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44673 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506AbaICMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/37] staging: comedi: ni_at_a2150: use CMDF_PRIORITY
Date: Wed,  3 Sep 2014 13:45:27 +0100
Message-Id: <1409748360-17063-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_RT` command flag with the equivalent flag
`CMDF_PRIORITY`.  The numeric value is unchanged.  Also replace
"TRIG_RT" with "CMDF_PRIORITY" in the kernel messages.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index de67161..fca22c5 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -511,9 +511,9 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	unsigned int old_config_bits = devpriv->config_bits;
 	unsigned int trigger_bits;
 
-	if (cmd->flags & TRIG_RT) {
+	if (cmd->flags & CMDF_PRIORITY) {
 		dev_err(dev->class_dev,
-			"dma incompatible with hard real-time interrupt (TRIG_RT), aborting\n");
+			"dma incompatible with hard real-time interrupt (CMDF_PRIORITY), aborting\n");
 		return -1;
 	}
 	/*  clear fifo and reset triggering circuitry */
-- 
2.1.0

