Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3FDOUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:20:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3FDOIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 33/70] drivers/leds/leds-ot200.c: fix error caused by shifted mask
Date: Tue,  4 Jun 2013 15:06:49 +0100
Message-Id: <1370354846-14213-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Gmeiner <christian.gmeiner@gmail.com>

commit 4b949b8af12e24b8a48fa5bb775a13b558d9f4da upstream.

During the development of this driver an in-house register documentation
was used.  The last week some integration tests were done and this
problem was found.  It turned out that the released register
documentation is wrong.

The fix is very simple: shift all masks by one.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/leds/leds-ot200.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
index c464682..676e729 100644
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
1.8.1.2

