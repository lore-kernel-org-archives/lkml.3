Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaDGU2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:28:24 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37603 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbaDGU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:28:20 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH v2 5/5] Staging: rts5139: More appropriate sizeof operand
Date: Mon,  7 Apr 2014 22:27:48 +0200
Message-Id: <1396902468-27906-6-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
References: <20140407003341.GA13365@kroah.com>
 <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the pointer rts51x to get the size of the struct.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5139/rts51x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index a55b97e..b732d2a 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -723,7 +723,7 @@ static int rts51x_probe(struct usb_interface *intf,
 
 	RTS51X_DEBUGP("%s detected\n", RTS51X_NAME);
 
-	rts51x = kzalloc(sizeof(struct rts51x_usb), GFP_KERNEL);
+	rts51x = kzalloc(sizeof(*rts51x), GFP_KERNEL);
 	if (!rts51x) {
 		pr_warn(RTS51X_TIP
 			"Unable to allocate rts51x_usb\n");
-- 
1.9.1

