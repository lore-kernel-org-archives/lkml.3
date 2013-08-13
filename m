Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab3HMRcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:32:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45678 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975Ab3HMR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:29:57 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v3 5/6] drivers: clocksource: enable hwcaps for event stream on ARM arch timer
Date: Tue, 13 Aug 2013 18:29:43 +0100
Message-Id: <1376414984-14182-6-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 13 Aug 2013 17:29:53.0878 (UTC) FILETIME=[B8FAF760:01CE984A]
X-MC-Unique: 113081318295509101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7DHWuhw000854

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch enables hwcap definition to the users for event stream
feature on ARM architected timers.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/clocksource/arm_arch_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6301ee5..05d1e13 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -162,6 +162,9 @@ static int arch_timer_setup(struct clock_event_device *clk)
 		pos--;
 	arch_counter_set_user_access(min(pos, 15));
 
+	/* enable hwcap definition to the users for event stream feature */
+	arch_timer_set_hwcap_evtstrm();
+
 	return 0;
 }
 
-- 
1.8.1.2


