Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3ISKr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:47:27 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:38967 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3ISKr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:47:26 -0400
Message-ID: <523AD63A.8040906@gmail.com>
Date: Thu, 19 Sep 2013 12:47:22 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] clocksource: of: respect device tree node status
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

diff --git a/drivers/clocksource/clksrc-of.c 
b/drivers/clocksource/clksrc-of.c
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

