Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbbA0H1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 02:27:16 -0500
Received: from mout.gmx.net ([212.227.15.18]:52807 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbbA0H1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 02:27:14 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ARM: clocksource: fix compile of asm9260_timer driver on ARCH=parisc
Date: Tue, 27 Jan 2015 08:27:04 +0100
Message-Id: <1422343624-9764-1-git-send-email-linux@rempel-privat.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <54BE5E9A.8070502@linaro.org>
References: <54BE5E9A.8070502@linaro.org>
X-Provags-ID: V03:K0:r8Xt6IQJOnrBzqt9Iii30+9S+OR2SuDG9YfVjTXXm9iCF6pL97b
 uENb1kW9q5UjzsRZZ8ibIfZa0TpiCXoPaJP+z4ClvXBx1g+C24Du++W7hfplYnGjQwwZWgv
 qNnHPbQ96jWPPkToE+1gcMHiKyTAAbmP7aguvTRc4e0HNEvIMo0ZXGqRv/XsXdQUhhG63ab
 a0uU993T6qeN1deSjiRBw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make sure this driver depends on GENERIC_CLOCKEVENTS

compiler error was found by kbuild test robot:

>> drivers/clocksource/asm9260_timer.c:114:14: warning: its scope is only this definition or declaration, which is probably not what you want
>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'struct clock_event_device' declared inside parameter list
            struct clock_event_device *evt)

>> drivers/clocksource/asm9260_timer.c:124:16: warning: 'enum clock_event_mode' declared inside parameter list
>> drivers/clocksource/asm9260_timer.c:123:58: error: parameter 1 ('mode') has incomplete type
    static void asm9260_timer_set_mode(enum clock_event_mode mode,

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 13b8152..bfaaae4 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -231,6 +231,7 @@ config CLKSRC_MIPS_GIC
 
 config ASM9260_TIMER
 	bool "Alphascale ASM9260 timer driver"
+	depends on GENERIC_CLOCKEVENTS
 	select CLKSRC_MMIO
 	select CLKSRC_OF
 	default y if MACH_ASM9260
-- 
1.9.1

