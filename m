Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbbA2NIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:08:48 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43893 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbbA2NIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:08:44 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry.Song@csr.com, baruch@tkos.co.il, linux@rempel-privat.de,
        rob.herring@linaro.org, thierry.reding@gmail.com
Subject: [PATCH 8/9] clocksource: versatile: Adapt for Versatile AB and PB boards
Date: Thu, 29 Jan 2015 14:08:18 +0100
Message-Id: <1422536899-16609-8-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
References: <54CA3044.6070501@linaro.org>
 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The same 24MHz counter is also present on Versatile AB and PB boards, so
add the compatible string for them.

Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/versatile.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/versatile.c b/drivers/clocksource/versatile.c
index 2798e74..0a26d3d 100644
--- a/drivers/clocksource/versatile.c
+++ b/drivers/clocksource/versatile.c
@@ -36,5 +36,7 @@ static void __init versatile_sched_clock_init(struct device_node *node)
 
 	sched_clock_register(versatile_sys_24mhz_read, 32, 24000000);
 }
-CLOCKSOURCE_OF_DECLARE(versatile, "arm,vexpress-sysreg",
+CLOCKSOURCE_OF_DECLARE(vexpress, "arm,vexpress-sysreg",
+		       versatile_sched_clock_init);
+CLOCKSOURCE_OF_DECLARE(versatile, "arm,versatile-sysreg",
 		       versatile_sched_clock_init);
-- 
1.9.1

