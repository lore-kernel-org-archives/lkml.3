Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbbAPQ5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:57:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35792 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbbAPQ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:57:30 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 2/2] clocksource: don't suspend/resume when unused
Date: Fri, 16 Jan 2015 17:57:19 +0100
Message-Id: <1421427439-11699-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in calling suspend/resume for unused
clocksources.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 kernel/time/clocksource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 03cfc5a08e3b..da65b3b73a86 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -493,7 +493,7 @@ void clocksource_suspend(void)
 	struct clocksource *cs;
 
 	list_for_each_entry_reverse(cs, &clocksource_list, list)
-		if (cs->suspend)
+		if (cs->suspend && (cs->flags & CLOCK_SOURCE_USED))
 			cs->suspend(cs);
 }
 
@@ -505,7 +505,7 @@ void clocksource_resume(void)
 	struct clocksource *cs;
 
 	list_for_each_entry(cs, &clocksource_list, list)
-		if (cs->resume)
+		if (cs->resume && (cs->flags & CLOCK_SOURCE_USED))
 			cs->resume(cs);
 
 	clocksource_resume_watchdog();
-- 
2.1.0

