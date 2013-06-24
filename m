Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3FXXpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:45:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FXXpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:45:45 -0400
Date: Mon, 24 Jun 2013 16:45:31 -0700
From: tip-bot for Fabio Estevam <tipbot@zytor.com>
Message-ID: <tip-2699339361a9bacb3fa663e6b8981a040cfca4ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fabio.estevam@freescale.com, tglx@linutronix.de, festevam@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fabio.estevam@freescale.com, tglx@linutronix.de, festevam@gmail.com
In-Reply-To: <1372116008-2323-1-git-send-email-festevam@gmail.com>
References: <1372116008-2323-1-git-send-email-festevam@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: vf_pit_timer: Use linux/
 sched_clock.h
Git-Commit-ID: 2699339361a9bacb3fa663e6b8981a040cfca4ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 24 Jun 2013 16:45:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2699339361a9bacb3fa663e6b8981a040cfca4ee
Gitweb:     http://git.kernel.org/tip/2699339361a9bacb3fa663e6b8981a040cfca4ee
Author:     Fabio Estevam <festevam@gmail.com>
AuthorDate: Mon, 24 Jun 2013 20:20:08 -0300
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 01:41:48 +0200

clocksource: vf_pit_timer: Use linux/sched_clock.h

Commit 38ff87f7 (sched_clock: Make ARM's sched_clock generic for all
architectures) changed the header to <linux/sched_clock.h>, so adapt
it in order to fix the following build error:

drivers/clocksource/vf_pit_timer.c:15:29: fatal error: asm/sched_clock.h: No such file or directory

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: shawn.guo@linaro.org
Cc: sboyd@codeaurora.org
Cc: john.stultz@linaro.org
Link: http://lkml.kernel.org/r/1372116008-2323-1-git-send-email-festevam@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/vf_pit_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index 598399d..587e020 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -12,7 +12,7 @@
 #include <linux/clk.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 /*
  * Each pit takes 0x10 Bytes register space
