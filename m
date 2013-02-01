Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab3BAUnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:43:22 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21465 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab3BAUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:17 -0500
Message-ID: <201302012043.r11KhGbQ024367@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 12:59:36 -0500
Subject: [PATCH] drivers/input/joystick/analog.c: enable precise timer
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like nm10300, tile can just use get_cycles() for this.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/input/joystick/analog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 358cd7e..7cd74e2 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -162,7 +162,7 @@ static unsigned int get_time_pit(void)
 #define GET_TIME(x)	do { x = get_cycles(); } while (0)
 #define DELTA(x,y)	((y)-(x))
 #define TIME_NAME	"PCC"
-#elif defined(CONFIG_MN10300)
+#elif defined(CONFIG_MN10300) || defined(CONFIG_TILE)
 #define GET_TIME(x)	do { x = get_cycles(); } while (0)
 #define DELTA(x, y)	((x) - (y))
 #define TIME_NAME	"TSC"
-- 
1.7.10.3

