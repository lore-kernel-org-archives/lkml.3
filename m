Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaEWKbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:31:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59913 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaEWKbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:48 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 09/71] clocksource: sh_cmt: Replace kmalloc + memset with kzalloc
Date: Fri, 23 May 2014 12:30:49 +0200
Message-Id: <1400841111-6683-9-git-send-email-daniel.lezcano@linaro.org>
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
---
 drivers/clocksource/sh_cmt.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 6b65621..0779bf1 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -672,8 +672,6 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 {
 	struct clock_event_device *ced = &ch->ced;
 
-	memset(ced, 0, sizeof(*ced));
-
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
@@ -709,7 +707,6 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	int irq;
 	int ret;
 
-	memset(ch, 0, sizeof(*ch));
 	ch->cmt = cmt;
 	ch->base = cmt->mapbase_ch;
 	ch->index = index;
@@ -758,7 +755,6 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	int ret;
 	ret = -ENXIO;
 
-	memset(cmt, 0, sizeof(*cmt));
 	cmt->pdev = pdev;
 
 	if (!cfg) {
@@ -861,7 +857,7 @@ static int sh_cmt_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	cmt = kmalloc(sizeof(*cmt), GFP_KERNEL);
+	cmt = kzalloc(sizeof(*cmt), GFP_KERNEL);
 	if (cmt == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
-- 
1.7.9.5

