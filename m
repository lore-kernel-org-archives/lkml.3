Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbaICMqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:19 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44652 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaICMqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:13 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/37] staging: comedi: comedi_test: use CMDF_PRIORITY
Date: Wed,  3 Sep 2014 13:45:24 +0100
Message-Id: <1409748360-17063-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of `TRIG_RT` command flag with the equivalent flag
`CMDF_PRIORITY`.  The numeric value is unchanged.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/comedi_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 7aa23db..00c03df 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -302,7 +302,7 @@ static int waveform_ai_cmd(struct comedi_device *dev,
 	struct waveform_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
-	if (cmd->flags & TRIG_RT) {
+	if (cmd->flags & CMDF_PRIORITY) {
 		dev_err(dev->class_dev,
 			"commands at RT priority not supported in this driver\n");
 		return -1;
-- 
2.1.0

