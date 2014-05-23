Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaEWKbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:31:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50791 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaEWKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:43 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/71] clocksource: sh_cmt: Constify name argument to sh_cmt_register()
Date: Fri, 23 May 2014 12:30:45 +0200
Message-Id: <1400841111-6683-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The name argument is assigned to const structure fields only, constify
it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 26f73cf..febd6bf 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -549,7 +549,7 @@ static void sh_cmt_clocksource_resume(struct clocksource *cs)
 }
 
 static int sh_cmt_register_clocksource(struct sh_cmt_channel *ch,
-				       char *name, unsigned long rating)
+				       const char *name, unsigned long rating)
 {
 	struct clocksource *cs = &ch->cs;
 
@@ -660,7 +660,7 @@ static void sh_cmt_clock_event_resume(struct clock_event_device *ced)
 }
 
 static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
-				       char *name, unsigned long rating)
+				       const char *name, unsigned long rating)
 {
 	struct clock_event_device *ced = &ch->ced;
 
@@ -680,7 +680,7 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 	clockevents_register_device(ced);
 }
 
-static int sh_cmt_register(struct sh_cmt_channel *ch, char *name,
+static int sh_cmt_register(struct sh_cmt_channel *ch, const char *name,
 			   unsigned long clockevent_rating,
 			   unsigned long clocksource_rating)
 {
@@ -717,7 +717,7 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch,
 	ch->match_value = ch->max_match_value;
 	raw_spin_lock_init(&ch->lock);
 
-	ret = sh_cmt_register(ch, (char *)dev_name(&cmt->pdev->dev),
+	ret = sh_cmt_register(ch, dev_name(&cmt->pdev->dev),
 			      cfg->clockevent_rating,
 			      cfg->clocksource_rating);
 	if (ret) {
-- 
1.7.9.5

