Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207Ab3BMPf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:35:29 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:47553 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934188Ab3BMPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:35:26 -0500
From: Christian Gmeiner <christian.gmeiner@gmail.com>
To: cooloney@gmail.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH] leds-ot200: Fix misbehavior caused by wrong bit masks
Date: Wed, 13 Feb 2013 16:58:30 +0100
Message-Id: <1360771110-9490-1-git-send-email-christian.gmeiner@gmail.com>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the development of this driver an in-house register
documentation was used. The last weeks some integration tests
were done and this problem was found. It turned out that
the released register documentation is wrong.

The fix is very simple: shift all masks by one.

Our customers can control LEDs from userspace via Java,
C++ or what every. They have running/working applications where
they want to control led_3 but led_2 get's used.
I got a bug report in our in-house bug tracker so it would be
great to fix this upstream.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/leds/leds-ot200.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
index ee14662..98cae52 100644
--- a/drivers/leds/leds-ot200.c
+++ b/drivers/leds/leds-ot200.c
@@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
 	{
 		.name = "led_1",
 		.port = 0x49,
-		.mask = BIT(7),
+		.mask = BIT(6),
 	},
 	{
 		.name = "led_2",
 		.port = 0x49,
-		.mask = BIT(6),
+		.mask = BIT(5),
 	},
 	{
 		.name = "led_3",
 		.port = 0x49,
-		.mask = BIT(5),
+		.mask = BIT(4),
 	},
 	{
 		.name = "led_4",
 		.port = 0x49,
-		.mask = BIT(4),
+		.mask = BIT(3),
 	},
 	{
 		.name = "led_5",
 		.port = 0x49,
-		.mask = BIT(3),
+		.mask = BIT(2),
 	},
 	{
 		.name = "led_6",
 		.port = 0x49,
-		.mask = BIT(2),
+		.mask = BIT(1),
 	},
 	{
 		.name = "led_7",
 		.port = 0x49,
-		.mask = BIT(1),
+		.mask = BIT(0),
 	}
 };
 
-- 
1.7.12.2.421.g261b511

