Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbaJ3Ms5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:48:57 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:50798 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759824AbaJ3Mm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:42:56 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] staging: comedi: me4000: don't clobber command flags
Date: Thu, 30 Oct 2014 12:42:27 +0000
Message-Id: <1414672952-1587-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The low-level Comedi drivers shouldn't change the `flags` member of
`struct comedi_cmd` as the Comedi core also uses some of those flags.
They should just ignore the flags they don't understand.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/me4000.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 6516ac0..6e73e6e 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -848,9 +848,6 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	unsigned int scan_ticks;
 	int err = 0;
 
-	/* Only rounding flags are implemented */
-	cmd->flags &= CMDF_ROUND_NEAREST | CMDF_ROUND_UP | CMDF_ROUND_DOWN;
-
 	/* Round the timer arguments */
 	ai_round_cmd_args(dev, s, cmd, &init_ticks, &scan_ticks, &chan_ticks);
 
-- 
2.1.1

