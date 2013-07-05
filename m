Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3GEWSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:18:53 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52564 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3GEWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:18:50 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv4 02/10] clocksource: sun4i: Wrap macros arguments in parenthesis
Date: Sat,  6 Jul 2013 00:18:37 +0200
Message-Id: <1373062725-19625-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macros were not using parenthesis to escape the arguments passed to
them. It is pretty unsafe, so add those parenthesis.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index bdf34d9..34ab658 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -30,8 +30,8 @@
 #define TIMER_CTL_ENABLE		BIT(0)
 #define TIMER_CTL_AUTORELOAD		BIT(1)
 #define TIMER_CTL_ONESHOT		BIT(7)
-#define TIMER_INTVAL_REG(val)	(0x10 * val + 0x14)
-#define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
+#define TIMER_INTVAL_REG(val)	(0x10 * (val) + 0x14)
+#define TIMER_CNTVAL_REG(val)	(0x10 * (val) + 0x18)
 
 #define TIMER_SCAL		16
 
-- 
1.8.3.2

