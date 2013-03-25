Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3CYJ6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:58:42 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:63544 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab3CYJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:58:39 -0400
Message-ID: <1364205517.1390.264.camel@x61.thuisdomein>
Subject: [PATCH] clocksource: rename "CONFIG_NOMADIK_MTU_SCHED_CLOCK"
From: Paul Bolle <pebolle@tiscali.nl>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 10:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 09:58:37.0962 (UTC) FILETIME=[523B4EA0:01CE293F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the things that commit 694e33a7f42de7dcc8b43c3990c597b19ef9b438
("ARM: plat-nomadik: move MTU, kill plat-nomadik") did was to rename
Kconfig symbol NOMADIK_MTU_SCHED_CLOCK to
CLKSRC_NOMADIK_MTU_SCHED_CLOCK. It forgot to rename two references to
the related macro in the code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Not even compile tested. Should go into stable for 3.8, after testing.

 drivers/clocksource/nomadik-mtu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 071f6ea..e405531 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -67,7 +67,7 @@ static u32 clk_prescale;
 static u32 nmdk_cycle;		/* write-once */
 static struct delay_timer mtu_delay_timer;
 
-#ifdef CONFIG_NOMADIK_MTU_SCHED_CLOCK
+#ifdef CONFIG_CLKSRC_NOMADIK_MTU_SCHED_CLOCK
 /*
  * Override the global weak sched_clock symbol with this
  * local implementation which uses the clocksource to get some
@@ -233,7 +233,7 @@ void __init nmdk_timer_init(void __iomem *base, int irq)
 		pr_err("timer: failed to initialize clock source %s\n",
 		       "mtu_0");
 
-#ifdef CONFIG_NOMADIK_MTU_SCHED_CLOCK
+#ifdef CONFIG_CLKSRC_NOMADIK_MTU_SCHED_CLOCK
 	setup_sched_clock(nomadik_read_sched_clock, 32, rate);
 #endif
 
-- 
1.7.11.7

