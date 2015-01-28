Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbbA1Usq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:48:46 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:39136 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbbA1Usn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:48:43 -0500
From: Rob Herring <robh@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 2/3] clocksource: versatile: adapt for Versatile AB and PB boards
Date: Wed, 28 Jan 2015 11:56:31 -0600
Message-Id: <1422467792-2065-3-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422467792-2065-1-git-send-email-robh@kernel.org>
References: <1422467792-2065-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same 24MHz counter is also present on Versatile AB and PB boards, so
add the compatible string for them.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
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
2.1.0

