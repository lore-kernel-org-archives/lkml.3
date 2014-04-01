Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaDALSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaDALSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Agner <stefan@agner.ch>, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/144] clocksource: vf_pit_timer: use complement for sched_clock reading
Date: Tue,  1 Apr 2014 12:15:18 +0100
Message-Id: <1396350948-29910-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Agner <stefan@agner.ch>

commit 224aa3ed45c8735ae02bb2ecca002409fa6aa772 upstream.

Vybrids PIT register is monitonic decreasing. However, sched_clock
reading needs to be monitonic increasing. Use bitwise not to get
the complement of the clock register. This fixes the clock going
backward. Also, the clock now starts at 0 since we load the
register with the maximum value at start.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Cc: daniel.lezcano@linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk
Link: http://lkml.kernel.org/r/d25af915993aec1b486be653eb86f748ddef54fe.1394057313.git.stefan@agner.ch
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clocksource/vf_pit_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index 587e020..e559095 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(void)
 
 static unsigned int pit_read_sched_clock(void)
 {
-	return __raw_readl(clksrc_base + PITCVAL);
+	return ~__raw_readl(clksrc_base + PITCVAL);
 }
 
 static int __init pit_clocksource_init(unsigned long rate)
-- 
1.9.1

