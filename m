Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaCYJCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:02:30 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63237 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaCYJC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:02:27 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Mark Brown <broonie@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH] arm64: Fix duplicated Kconfig entries again
Date: Tue, 25 Mar 2014 17:00:59 +0800
Message-Id: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 74397174989e5 (arm64: Fix duplicated Kconfig entries),
I still get a duplicate Power management options section in linux-next
git repo, may be due to some merge conflicts, anyway, fix that in this
patch.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
Based on linux-next repo, weird, did I miss something?
---
 arch/arm64/Kconfig |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index d9f23ad..6085dca 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -317,24 +317,12 @@ config ARCH_SUSPEND_POSSIBLE
 config ARM64_CPU_SUSPEND
 	def_bool PM_SLEEP
 
-endmenu
-
-menu "CPU Power Management"
-
 source "drivers/cpuidle/Kconfig"
 
 source "drivers/cpufreq/Kconfig"
 
 endmenu
 
-menu "Power management options"
-
-source "kernel/power/Kconfig"
-
-source "drivers/cpufreq/Kconfig"
-
-endmenu
-
 source "net/Kconfig"
 
 source "drivers/Kconfig"
-- 
1.7.9.5

