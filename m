Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaJSKWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 06:22:45 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58253 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJSKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 06:22:41 -0400
From: Tomas Melin <tomas.melin@iki.fi>
To: m.chehab@samsung.com, david@hardeman.nu
Cc: james.hogan@imgtec.com, a.seppala@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomas Melin <tomas.melin@iki.fi>
Subject: [PATCH 2/2] [media] rc-core: change enabled_protocol default setting
Date: Sun, 19 Oct 2014 13:21:53 +0300
Message-Id: <1413714113-7456-2-git-send-email-tomas.melin@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413714113-7456-1-git-send-email-tomas.melin@iki.fi>
References: <1413714113-7456-1-git-send-email-tomas.melin@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change default setting for enabled protocols.
Instead of enabling all protocols, disable all except lirc during registration.
Reduces overhead since all protocols not handled by default.
Protocol to use will be enabled when keycode table is written by userspace.

Signed-off-by: Tomas Melin <tomas.melin@iki.fi>
---
 drivers/media/rc/rc-ir-raw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index a118539..63d23d0 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -256,7 +256,8 @@ int ir_raw_event_register(struct rc_dev *dev)
 		return -ENOMEM;
 
 	dev->raw->dev = dev;
-	dev->enabled_protocols = ~0;
+	/* by default, disable all but lirc*/
+	dev->enabled_protocols = RC_BIT_LIRC;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
-- 
1.7.10.4

