Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbaICMxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:53:43 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44685 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbaICMqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/37] staging: comedi: ni_mio_common: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:39 +0100
Message-Id: <1409748360-17063-17-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_WAKE_EOS` command flag with the new name
`CMDF_WAKE_EOS`.  The numeric value is the same.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_mio_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 237e3f8..584de17 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -2610,7 +2610,7 @@ static int ni_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		interrupt_a_enable |= AI_FIFO_Interrupt_Enable;
 #endif
 
-		if (cmd->flags & TRIG_WAKE_EOS
+		if (cmd->flags & CMDF_WAKE_EOS
 		    || (devpriv->ai_cmd2 & AI_End_On_End_Of_Scan)) {
 			/* wake on end-of-scan */
 			devpriv->aimode = AIMODE_SCAN;
-- 
2.1.0

