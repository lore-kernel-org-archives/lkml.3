Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbaICM4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:56:35 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44690 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbaICMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:46:15 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/37] staging: comedi: use CMDF_WAKE_EOS in do_cmd_ioctl()
Date: Wed,  3 Sep 2014 13:45:30 +0100
Message-Id: <1409748360-17063-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
References: <1409748360-17063-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`TRIG_WAKE_EOS` is now just a synonym for `CMDF_WAKE_EOS`.  Change
`do_cmd_ioctl()` to use the new name.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 2182c74..9d60a39 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1558,7 +1558,7 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 	async->cb_mask =
 	    COMEDI_CB_EOA | COMEDI_CB_BLOCK | COMEDI_CB_ERROR |
 	    COMEDI_CB_OVERFLOW;
-	if (async->cmd.flags & TRIG_WAKE_EOS)
+	if (async->cmd.flags & CMDF_WAKE_EOS)
 		async->cb_mask |= COMEDI_CB_EOS;
 
 	comedi_set_subdevice_runflags(s, SRF_ERROR | SRF_RUNNING, SRF_RUNNING);
-- 
2.1.0

