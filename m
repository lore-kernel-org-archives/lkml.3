Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031170AbaLLRTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:19:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57744 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030759AbaLLRTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:19:34 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, <viresh.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <horms@verge.net.au>, <linux-sh@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: omap2plus_defconfig: use CONFIG_CPUFREQ_DT
Date: Fri, 12 Dec 2014 11:18:58 -0600
Message-ID: <1418404738-19124-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_GENERIC_CPUFREQ_CPU0 disappeared with commit bbcf071969b20f
("cpufreq: cpu0: rename driver and internals to 'cpufreq_dt'")

Use the renamed CONFIG_CPUFREQ_DT generic driver. It looks like with
v3.18-rc1, commit bbcf071969b20f and fdc509b15eb3eb came in via
different trees causing the resultant v3.18-rc1 to be non-functional for
cpufreq as default supported with omap2plus_defconfig.

Fixes: fdc509b15eb3eb ("ARM: omap2plus_defconfig: Add cpufreq to defconfig")
Signed-off-by: Nishanth Menon <nm@ti.com>
---

NOTE: as of v3.18 tag, The following still need to be fixed - I do not have all
the platforms impacted to make a generic change, so CCying folks who might be interested

arch/arm/configs/shmobile_defconfig:CONFIG_GENERIC_CPUFREQ_CPU0=y
arch/arm/configs/multi_v7_defconfig:CONFIG_GENERIC_CPUFREQ_CPU0=y

 arch/arm/configs/omap2plus_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 3e09286..5fc0dbe 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -68,7 +68,7 @@ CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_POWERSAVE=y
 CONFIG_CPU_FREQ_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
-CONFIG_GENERIC_CPUFREQ_CPU0=y
+CONFIG_CPUFREQ_DT=y
 # CONFIG_ARM_OMAP2PLUS_CPUFREQ is not set
 CONFIG_CPU_IDLE=y
 CONFIG_BINFMT_MISC=y
-- 
1.7.9.5

