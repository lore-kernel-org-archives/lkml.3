Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab3ICMwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:52:34 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42859 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab3ICMwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:52:32 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] clocksource: of: respect device tree node status
Date: Tue,  3 Sep 2013 14:52:23 +0200
Message-Id: <1378212743-27843-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clocksource devices provided by DT can be disabled (status != "okay").
Instead of registering clocksource drivers for disabled nodes, respect
the device's status by skiping disabled nodes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
---
 drivers/clocksource/clksrc-of.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index 37f5325..b9ddd9e 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -30,6 +30,9 @@ void __init clocksource_of_init(void)
 	clocksource_of_init_fn init_func;
 
 	for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
+		if (!of_device_is_available(np))
+			continue;
+
 		init_func = match->data;
 		init_func(np);
 	}
-- 
1.7.2.5

