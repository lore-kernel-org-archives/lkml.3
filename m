Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaEWKcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37490 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaEWKcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:31 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 44/71] clocksource: sh_mtu2: Replace kmalloc + memset with kzalloc
Date: Fri, 23 May 2014 12:31:24 +0200
Message-Id: <1400841111-6683-44-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

One kzalloc a day keeps the bugs away.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 61827c6..94a5342 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -241,8 +241,6 @@ static void sh_mtu2_register_clockevent(struct sh_mtu2_channel *ch,
 	struct clock_event_device *ced = &ch->ced;
 	int ret;
 
-	memset(ced, 0, sizeof(*ced));
-
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->rating = rating;
@@ -279,7 +277,6 @@ static int sh_mtu2_setup_channel(struct sh_mtu2_channel *ch,
 {
 	struct sh_timer_config *cfg = mtu->pdev->dev.platform_data;
 
-	memset(ch, 0, sizeof(*ch));
 	ch->mtu = mtu;
 	ch->index = cfg->timer_bit;
 
@@ -302,7 +299,6 @@ static int sh_mtu2_setup(struct sh_mtu2_device *mtu,
 	int ret;
 	ret = -ENXIO;
 
-	memset(mtu, 0, sizeof(*mtu));
 	mtu->pdev = pdev;
 
 	if (!cfg) {
@@ -373,7 +369,7 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	mtu = kmalloc(sizeof(*mtu), GFP_KERNEL);
+	mtu = kzalloc(sizeof(*mtu), GFP_KERNEL);
 	if (mtu == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
-- 
1.7.9.5

