Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaICMqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:46:24 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44690 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704AbaICMqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/37] staging: comedi: use CMDF_BOGUS in do_cmd_ioctl()
Date: Wed,  3 Sep 2014 13:45:44 +0100
Message-Id: <1409748360-17063-22-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`TRIG_BOGUS` is now just a synonym for `CMDF_BOGUS`.  Change
`do_cmd_ioctl()` to use the new name.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 9d60a39..495969f 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1532,7 +1532,7 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 
 	ret = s->do_cmdtest(dev, s, &async->cmd);
 
-	if (async->cmd.flags & TRIG_BOGUS || ret) {
+	if (async->cmd.flags & CMDF_BOGUS || ret) {
 		dev_dbg(dev->class_dev, "test returned %d\n", ret);
 		cmd = async->cmd;
 		/* restore chanlist pointer before copying back */
-- 
2.1.0

