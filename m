Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3E0Jlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:41:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab3E0Jlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:41:44 -0400
Date: Mon, 27 May 2013 02:41:16 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-fc1f7d5606487ae28d6c84e95401952927d7379e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, jamie@jamieiles.com,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com, jamie@jamieiles.com
In-Reply-To: <20130425143435.558006195@linutronix.de>
References: <20130425143435.558006195@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: apb_timer: Remove unsused function
Git-Commit-ID: fc1f7d5606487ae28d6c84e95401952927d7379e
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

Commit-ID:  fc1f7d5606487ae28d6c84e95401952927d7379e
Gitweb:     http://git.kernel.org/tip/fc1f7d5606487ae28d6c84e95401952927d7379e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:13 +0200

clocksource: apb_timer: Remove unsused function

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Jamie Iles <jamie@jamieiles.com>
Link: http://lkml.kernel.org/r/20130425143435.558006195@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/dw_apb_timer.c | 12 ------------
 include/linux/dw_apb_timer.h       |  1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/clocksource/dw_apb_timer.c b/drivers/clocksource/dw_apb_timer.c
index 8c2a35f..e54ca10 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -387,15 +387,3 @@ cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs)
 {
 	return (cycle_t)~apbt_readl(&dw_cs->timer, APBTMR_N_CURRENT_VALUE);
 }
-
-/**
- * dw_apb_clocksource_unregister() - unregister and free a clocksource.
- *
- * @dw_cs:	The clocksource to unregister/free.
- */
-void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs)
-{
-	clocksource_unregister(&dw_cs->cs);
-
-	kfree(dw_cs);
-}
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index dd755ce..b1cd959 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -51,7 +51,6 @@ dw_apb_clocksource_init(unsigned rating, const char *name, void __iomem *base,
 void dw_apb_clocksource_register(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
-void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
 
 extern void dw_apb_timer_init(void);
 #endif /* __DW_APB_TIMER_H__ */
