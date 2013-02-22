Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab3BVP74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:59:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213Ab3BVP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:59:54 -0500
Date: Fri, 22 Feb 2013 07:58:35 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-00f4e13c4634b10f6a16b26a980b22a53dfa6bb5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1361547870-32638-1-git-send-email-daniel.lezcano@linaro.org>
References: <1361547870-32638-1-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clocksource : Nomadik-mtu :
  fix missing irq initialization
Git-Commit-ID: 00f4e13c4634b10f6a16b26a980b22a53dfa6bb5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 22 Feb 2013 07:58:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00f4e13c4634b10f6a16b26a980b22a53dfa6bb5
Gitweb:     http://git.kernel.org/tip/00f4e13c4634b10f6a16b26a980b22a53dfa6bb5
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Fri, 22 Feb 2013 16:44:30 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 22 Feb 2013 16:47:59 +0100

clocksource : Nomadik-mtu : fix missing irq initialization

This patch fix the clock device irq field which is not initialized.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Cc: linus.walleij@stericsson.com
Cc: john.stultz@linaro.org
Link: http://lkml.kernel.org/r/1361547870-32638-1-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/nomadik-mtu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 8914c3c..7cbcaa0 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -226,5 +226,6 @@ void __init nmdk_timer_init(void __iomem *base, int irq)
 	/* Timer 1 is used for events, register irq and clockevents */
 	setup_irq(irq, &nmdk_timer_irq);
 	nmdk_clkevt.cpumask = cpumask_of(0);
+	nmdk_clkevt.irq = irq;
 	clockevents_config_and_register(&nmdk_clkevt, rate, 2, 0xffffffffU);
 }
