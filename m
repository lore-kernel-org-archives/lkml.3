Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbaICMrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:47:41 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44698 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774AbaICMq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:28 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 35/37] staging: comedi: ni_pcidio: use CMDF_ROUND_...
Date: Wed,  3 Sep 2014 13:45:58 +0100
Message-Id: <1409748360-17063-36-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_pcidio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index b5b36af..ede8e41 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -530,15 +530,15 @@ static int ni_pcidio_ns_to_timer(int *nanosec, unsigned int flags)
 
 	base = TIMER_BASE;
 
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
@@ -669,7 +669,7 @@ static int ni_pcidio_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		writeb(3, dev->mmio + LinePolarities);
 		writeb(0xc0, dev->mmio + AckSer);
 		writel(ni_pcidio_ns_to_timer(&cmd->scan_begin_arg,
-					     TRIG_ROUND_NEAREST),
+					     CMDF_ROUND_NEAREST),
 		       dev->mmio + StartDelay);
 		writeb(1, dev->mmio + ReqDelay);
 		writeb(1, dev->mmio + ReqNotDelay);
-- 
2.1.0

