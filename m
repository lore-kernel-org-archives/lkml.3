Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867AbaJ3MnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:43:01 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:51350 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759842AbaJ3Mm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:42:58 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] staging: comedi: ni_mio_common: don't change CMDF_WRITE flag
Date: Thu, 30 Oct 2014 12:42:28 +0000
Message-Id: <1414672952-1587-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for `ni_ai_cmdtest()` or `ni_ao_cmdtest()` to set the
`CMDF_WRITE` flag to the correct state as it has already been done by
the core comedi module.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_mio_common.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 785ad70..852b645 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -2251,9 +2251,6 @@ static int ni_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	/* Step 1 : check if triggers are trivially valid */
 
-	if ((cmd->flags & CMDF_WRITE))
-		cmd->flags &= ~CMDF_WRITE;
-
 	err |= cfc_check_trigger_src(&cmd->start_src,
 					TRIG_NOW | TRIG_INT | TRIG_EXT);
 	err |= cfc_check_trigger_src(&cmd->scan_begin_src,
@@ -3286,9 +3283,6 @@ static int ni_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	/* Step 1 : check if triggers are trivially valid */
 
-	if ((cmd->flags & CMDF_WRITE) == 0)
-		cmd->flags |= CMDF_WRITE;
-
 	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_INT | TRIG_EXT);
 	err |= cfc_check_trigger_src(&cmd->scan_begin_src,
 					TRIG_TIMER | TRIG_EXT);
-- 
2.1.1

