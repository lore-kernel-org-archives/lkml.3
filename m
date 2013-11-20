Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3KTUCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:02:13 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41845 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3KTUCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:02:12 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        will.deacon@arm.com, catalin.marinas@arm.com, olof@lixom.net,
        sudeep.karkadanagesha@arm.com
Subject: [PATCH] drivers: clocksource: Hide arm_arch_timer eventstream Kconfig on non-ARM
Date: Wed, 20 Nov 2013 12:02:03 -0800
Message-Id: <1384977723-32344-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc2
In-Reply-To: <20131120192100.GA11723@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek reports that this config is exposed on x86 where the
ARM architected timers aren't even present. Make it depend on the
ARM architected timers being selected so that non-ARM builds
aren't asked about it.

Reported-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index bdb953e..5c07a56 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -87,6 +87,7 @@ config ARM_ARCH_TIMER
 config ARM_ARCH_TIMER_EVTSTREAM
 	bool "Support for ARM architected timer event stream generation"
 	default y if ARM_ARCH_TIMER
+	depends on ARM_ARCH_TIMER
 	help
 	  This option enables support for event stream generation based on
 	  the ARM architected timer. It is used for waking up CPUs executing
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

