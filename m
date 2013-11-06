Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3KFOVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:21:45 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:57229 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403Ab3KFOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:21:43 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org (open list:SMIA AND SMIA++ I...),
        linux-kernel@vger.kernel.org (open list)
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] smiapp: Fix BUG_ON() on an impossible condition
Date: Wed,  6 Nov 2013 15:21:30 +0100
Message-Id: <1383747690-20003-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

internal_csi_format_idx and csi_format_idx are unsigned integers,
therefore they can never be nevative.

CC      drivers/media/i2c/smiapp/smiapp-core.o
In file included from include/linux/err.h:4:0,
                 from include/linux/clk.h:15,
                 from drivers/media/i2c/smiapp/smiapp-core.c:29:
drivers/media/i2c/smiapp/smiapp-core.c: In function ‘smiapp_update_mbus_formats’:
include/linux/kernel.h:669:20: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
 #define min(x, y) ({    \
                    ^
include/linux/compiler.h:153:42: note: in definition of macro ‘unlikely’
 # define unlikely(x) __builtin_expect(!!(x), 0)
                                          ^
drivers/media/i2c/smiapp/smiapp-core.c:402:2: note: in expansion of macro ‘BUG_ON’
  BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
  ^
drivers/media/i2c/smiapp/smiapp-core.c:402:9: note: in expansion of macro ‘min’
  BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
         ^

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index ae66d91..fbd48f0 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -399,7 +399,6 @@ static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
 
 	BUG_ON(max(internal_csi_format_idx, csi_format_idx) + pixel_order
 	       >= ARRAY_SIZE(smiapp_csi_data_formats));
-	BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
 
 	dev_dbg(&client->dev, "new pixel order %s\n",
 		pixel_order_str[pixel_order]);
-- 
1.8.4.rc3

