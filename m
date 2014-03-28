Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaC1Ra4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:30:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaC1Rax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: [PATCH 3.13 03/46] clocksource: vf_pit_timer: use complement for sched_clock reading
Date: Fri, 28 Mar 2014 10:31:47 -0700
Message-Id: <20140328173135.096192258@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/vf_pit_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(v
 
 static u64 pit_read_sched_clock(void)
 {
-	return __raw_readl(clksrc_base + PITCVAL);
+	return ~__raw_readl(clksrc_base + PITCVAL);
 }
 
 static int __init pit_clocksource_init(unsigned long rate)


