Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3A0Iwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 03:52:55 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:34581 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab3A0Iww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 03:52:52 -0500
Message-ID: <1359276768.5165.2.camel@phoenix>
Subject: [PATCH] backlight: 88pm860x_bl: Add missing of_node_put()
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Date: Sun, 27 Jan 2013 16:52:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() returns a node pointer with refcount incremented, use
of_node_put() on it when done.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/video/backlight/88pm860x_bl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index c072ed9..4d2782f 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -184,6 +184,7 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
 			break;
 		}
 	}
+	of_node_put(nproot);
 	return 0;
 }
 #else
-- 
1.7.9.5



