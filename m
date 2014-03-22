Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbaCVKca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 06:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaCVKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 06:32:27 -0400
Date: Sat, 22 Mar 2014 03:31:47 -0700
From: tip-bot for Geert Uytterhoeven <tipbot@zytor.com>
Message-ID: <tip-87291a9267ecc0a8efceb4d9cbd4da870f958fc1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        damm@opensource.se, geert+renesas@glider.be, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        damm@opensource.se, geert+renesas@glider.be, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <1395324352-9146-1-git-send-email-geert@linux-m68k.org>
References: <1395324352-9146-1-git-send-email-geert@linux-m68k.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: CMT, MTU2,
  TMU and STI should depend on GENERIC_CLOCKEVENTS
Git-Commit-ID: 87291a9267ecc0a8efceb4d9cbd4da870f958fc1
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

Commit-ID:  87291a9267ecc0a8efceb4d9cbd4da870f958fc1
Gitweb:     http://git.kernel.org/tip/87291a9267ecc0a8efceb4d9cbd4da870f958fc1
Author:     Geert Uytterhoeven <geert+renesas@glider.be>
AuthorDate: Thu, 20 Mar 2014 15:05:50 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 22 Mar 2014 11:29:29 +0100

clocksource: CMT, MTU2, TMU and STI should depend on GENERIC_CLOCKEVENTS

If GENERIC_CLOCKEVENTS=n:

drivers/clocksource/sh_cmt.c:54:28: error: field 'ced' has incomplete type
drivers/clocksource/sh_cmt.c: In function 'sh_cmt_interrupt':
drivers/clocksource/sh_cmt.c:407:23: error: 'CLOCK_EVT_MODE_ONESHOT' undeclared (first use in this function)

drivers/clocksource/sh_mtu2.c:44:28: error: field 'ced' has incomplete type
drivers/clocksource/sh_mtu2.c: In function 'ced_to_sh_mtu2':
drivers/clocksource/sh_mtu2.c:184:70: warning: initialization from incompatible pointer type [enabled by default]
drivers/clocksource/sh_mtu2.c: At top level:
drivers/clocksource/sh_mtu2.c:188:16: warning: 'enum clock_event_mode' declared inside parameter list [enabled by default]

drivers/clocksource/sh_tmu.c:45:28: error: field 'ced' has incomplete type
drivers/clocksource/sh_tmu.c: In function 'sh_tmu_interrupt':
drivers/clocksource/sh_tmu.c:207:21: error: 'CLOCK_EVT_MODE_ONESHOT' undeclared (first use in this function)

drivers/clocksource/em_sti.c:44:28: error: field 'ced' has incomplete type
drivers/clocksource/em_sti.c: In function 'ced_to_em_sti':
drivers/clocksource/em_sti.c:251:69: warning: initialization from incompatible pointer type [enabled by default]
drivers/clocksource/em_sti.c: At top level:
drivers/clocksource/em_sti.c:255:16: warning: 'enum clock_event_mode' declared inside parameter list [enabled by default]

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <damm@opensource.se>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: http://lkml.kernel.org/r/1395324352-9146-1-git-send-email-geert@linux-m68k.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 4f754a9..52e9329 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -155,6 +155,7 @@ config SYS_SUPPORTS_EM_STI
 
 config SH_TIMER_CMT
 	bool "Renesas CMT timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
 	default SYS_SUPPORTS_SH_CMT
 	help
 	  This enables build of a clocksource and clockevent driver for
@@ -163,6 +164,7 @@ config SH_TIMER_CMT
 
 config SH_TIMER_MTU2
 	bool "Renesas MTU2 timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
 	default SYS_SUPPORTS_SH_MTU2
 	help
 	  This enables build of a clockevent driver for the Multi-Function
@@ -171,6 +173,7 @@ config SH_TIMER_MTU2
 
 config SH_TIMER_TMU
 	bool "Renesas TMU timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
 	default SYS_SUPPORTS_SH_TMU
 	help
 	  This enables build of a clocksource and clockevent driver for
@@ -179,6 +182,7 @@ config SH_TIMER_TMU
 
 config EM_TIMER_STI
 	bool "Renesas STI timer driver" if COMPILE_TEST
+	depends on GENERIC_CLOCKEVENTS
 	default SYS_SUPPORTS_EM_STI
 	help
 	  This enables build of a clocksource and clockevent driver for
