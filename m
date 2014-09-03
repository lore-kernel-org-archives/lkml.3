Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaICMwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:52:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44695 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663AbaICMqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:20 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/37] staging: comedi: pcl812: use CMDF_WAKE_EOS
Date: Wed,  3 Sep 2014 13:45:41 +0100
Message-Id: <1409748360-17063-19-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_WAKE_EOS` command flag with the new name
`CMDF_WAKE_EOS`.  The numeric value is unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/pcl812.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 55620c9..61549e3 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -812,7 +812,7 @@ static int pcl812_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	s->async->cur_chan = 0;
 
 	/*  don't we want wake up every scan? */
-	if (cmd->flags & TRIG_WAKE_EOS) {
+	if (cmd->flags & CMDF_WAKE_EOS) {
 		devpriv->ai_eos = 1;
 
 		/*  DMA is useless for this situation */
-- 
2.1.0

