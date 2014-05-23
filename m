Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaEWKbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:31:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:32875 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaEWKbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:46 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/71] clocksource: sh_cmt: Add memory base to sh_cmt_channel structure
Date: Fri, 23 May 2014 12:30:47 +0200
Message-Id: <1400841111-6683-7-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The channel memory base is channel-specific, add it to the channel
structure in preparation for support of multiple channels per device.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index eb93b88..4fcb05d 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -40,6 +40,8 @@ struct sh_cmt_device;
 struct sh_cmt_channel {
 	struct sh_cmt_device *cmt;
 
+	void __iomem *base;
+
 	unsigned long flags;
 	unsigned long match_value;
 	unsigned long next_match_value;
@@ -130,12 +132,12 @@ static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 
 static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_control(ch->cmt->mapbase_ch, CMCSR);
+	return ch->cmt->read_control(ch->base, CMCSR);
 }
 
 static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_count(ch->cmt->mapbase_ch, CMCNT);
+	return ch->cmt->read_count(ch->base, CMCNT);
 }
 
 static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
@@ -147,19 +149,19 @@ static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
 static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_control(ch->cmt->mapbase_ch, CMCSR, value);
+	ch->cmt->write_control(ch->base, CMCSR, value);
 }
 
 static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_count(ch->cmt->mapbase_ch, CMCNT, value);
+	ch->cmt->write_count(ch->base, CMCNT, value);
 }
 
 static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_count(ch->cmt->mapbase_ch, CMCOR, value);
+	ch->cmt->write_count(ch->base, CMCOR, value);
 }
 
 static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
@@ -702,6 +704,7 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch,
 
 	memset(ch, 0, sizeof(*ch));
 	ch->cmt = cmt;
+	ch->base = cmt->mapbase_ch;
 
 	irq = platform_get_irq(cmt->pdev, 0);
 	if (irq < 0) {
-- 
1.7.9.5

