Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3CKNqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:46:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41548 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CKNqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:46:05 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] clocksource: add empty version of clocksource_of_init
Date: Mon, 11 Mar 2013 08:45:51 -0500
Message-Id: <1363009551-8978-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Add an empty clocksource_of_init when !CLKSRC_OF. This is needed for builds
where no timer has selected CLKSRC_OF.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
This is part of my CLKSRC_OF init rework. It is also needed for
Arnd's default machine patch. I plan to send a pull request to arm-soc
for all this shortly.

Rob

 include/linux/clocksource.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 27cfda4..08ed5e1 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -340,6 +340,7 @@ extern void clocksource_of_init(void);
 		__used __section(__clksrc_of_table)			\
 		 = { .compatible = compat, .data = fn };
 #else
+static inline void clocksource_of_init(void) {}
 #define CLOCKSOURCE_OF_DECLARE(name, compat, fn)
 #endif
 
-- 
1.7.10.4

