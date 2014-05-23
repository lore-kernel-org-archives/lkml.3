Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaEWKcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:45 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54696 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaEWKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:34 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 47/71] clocksource: sh_mtu2: Set cpumask to cpu_possible_mask
Date: Fri, 23 May 2014 12:31:27 +0200
Message-Id: <1400841111-6683-47-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The MTU2 is not tied to CPU0, make it usable on any CPU.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 2cf0048..702ce60 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -331,7 +331,7 @@ static void sh_mtu2_register_clockevent(struct sh_mtu2_channel *ch,
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->rating = rating;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_mode = sh_mtu2_clock_event_mode;
 	ced->suspend = sh_mtu2_clock_event_suspend;
 	ced->resume = sh_mtu2_clock_event_resume;
-- 
1.7.9.5

