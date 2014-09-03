Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaICMqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44657 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321AbaICMqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:13 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/37] staging: comedi: das16: use CMDF_PRIORITY
Date: Wed,  3 Sep 2014 13:45:25 +0100
Message-Id: <1409748360-17063-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_RT` command flag with the equivalent flag
`CMDF_PRIORITY`.  The numeric value is unchanged.  Also replace
"TRIG_RT" with "CMDF_PRIORITY" in kernel log messages.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/das16.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index a7b4981..aa52a5b 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -756,9 +756,9 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	unsigned long flags;
 	int range;
 
-	if (cmd->flags & TRIG_RT) {
+	if (cmd->flags & CMDF_PRIORITY) {
 		dev_err(dev->class_dev,
-			 "isa dma transfers cannot be performed with TRIG_RT, aborting\n");
+			 "isa dma transfers cannot be performed with CMDF_PRIORITY, aborting\n");
 		return -1;
 	}
 
-- 
2.1.0

