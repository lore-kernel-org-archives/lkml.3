Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaBNA7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:59:55 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaBNA7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:09 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/27] clocksource: sh_cmt: Replace kmalloc + memset with kzalloc
Date: Fri, 14 Feb 2014 01:59:45 +0100
Message-Id: <1392339605-20691-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One kzalloc a day keeps the bugs away.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 0796460..cd3121d 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -673,8 +673,6 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 {
 	struct clock_event_device *ced = &ch->ced;
 
-	memset(ced, 0, sizeof(*ced));
-
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
@@ -710,7 +708,6 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	int irq;
 	int ret;
 
-	memset(ch, 0, sizeof(*ch));
 	ch->cmt = cmt;
 	ch->base = cmt->mapbase_ch;
 	ch->index = index;
@@ -760,7 +757,6 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	int ret;
 	ret = -ENXIO;
 
-	memset(cmt, 0, sizeof(*cmt));
 	cmt->pdev = pdev;
 
 	if (!cfg) {
@@ -863,7 +859,7 @@ static int sh_cmt_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	cmt = kmalloc(sizeof(*cmt), GFP_KERNEL);
+	cmt = kzalloc(sizeof(*cmt), GFP_KERNEL);
 	if (cmt == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
-- 
1.8.3.2

