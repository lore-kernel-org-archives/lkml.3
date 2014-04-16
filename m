Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaDPJsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:48:31 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37439 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaDPJs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:48:29 -0400
Date: Wed, 16 Apr 2014 18:48:02 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: thomas.pugliese@gmail.com, daeseok.youn@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] uwb: adds missing error handling
Message-ID: <20140416094802.GA18148@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is checking NULL before dereferncing but
it need to add "return".

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/uwb/drp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/drp.c b/drivers/uwb/drp.c
index 16ada83..1a2fd97 100644
--- a/drivers/uwb/drp.c
+++ b/drivers/uwb/drp.c
@@ -599,8 +599,11 @@ static void uwb_drp_handle_alien_drp(struct uwb_rc *rc, struct uwb_ie_drp *drp_i
 
 	/* alloc and initialize new uwb_cnflt_alien */
 	cnflt = kzalloc(sizeof(struct uwb_cnflt_alien), GFP_KERNEL);
-	if (!cnflt)
+	if (!cnflt) {
 		dev_err(dev, "failed to alloc uwb_cnflt_alien struct\n");
+		return;
+	}
+
 	INIT_LIST_HEAD(&cnflt->rc_node);
 	init_timer(&cnflt->timer);
 	cnflt->timer.function = uwb_cnflt_timer;
-- 
1.7.4.4

