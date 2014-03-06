Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaCFKho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:37:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44133 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaCFKhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:37:41 -0500
Date: Thu, 6 Mar 2014 02:37:20 -0800
From: tip-bot for Stefan Agner <tipbot@zytor.com>
Message-ID: <tip-224aa3ed45c8735ae02bb2ecca002409fa6aa772@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, shawn.guo@linaro.org, stefan@agner.ch
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, stefan@agner.ch, shawn.guo@linaro.org
In-Reply-To: <d25af915993aec1b486be653eb86f748ddef54fe.1394057313.git.stefan@agner.ch>
References: <d25af915993aec1b486be653eb86f748ddef54fe.1394057313.git.stefan@agner.ch>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clocksource: vf_pit_timer:
  use complement for sched_clock reading
Git-Commit-ID: 224aa3ed45c8735ae02bb2ecca002409fa6aa772
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  224aa3ed45c8735ae02bb2ecca002409fa6aa772
Gitweb:     http://git.kernel.org/tip/224aa3ed45c8735ae02bb2ecca002409fa6aa772
Author:     Stefan Agner <stefan@agner.ch>
AuthorDate: Wed, 5 Mar 2014 23:11:08 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 6 Mar 2014 11:34:14 +0100

clocksource: vf_pit_timer: use complement for sched_clock reading

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/vf_pit_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index 02821b0..a918bc4 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(void)
 
 static u64 pit_read_sched_clock(void)
 {
-	return __raw_readl(clksrc_base + PITCVAL);
+	return ~__raw_readl(clksrc_base + PITCVAL);
 }
 
 static int __init pit_clocksource_init(unsigned long rate)
