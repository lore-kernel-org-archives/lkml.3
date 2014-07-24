Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846AbaGXJtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:49:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934797AbaGXJtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 113/128] cpufreq: Makefile: fix compilation for davinci platform
Date: Thu, 24 Jul 2014 10:46:02 +0100
Message-Id: <1406195177-8656-114-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prabhakar Lad <prabhakar.csengg@gmail.com>

commit 5a90af67c2126fe1d04ebccc1f8177e6ca70d3a9 upstream.

Since commtit 8a7b1227e303 (cpufreq: davinci: move cpufreq driver to
drivers/cpufreq) this added dependancy only for CONFIG_ARCH_DAVINCI_DA850
where as davinci_cpufreq_init() call is used by all davinci platform.

This patch fixes following build error:

arch/arm/mach-davinci/built-in.o: In function `davinci_init_late':
:(.init.text+0x928): undefined reference to `davinci_cpufreq_init'
make: *** [vmlinux] Error 1

Fixes: 8a7b1227e303 (cpufreq: davinci: move cpufreq driver to drivers/cpufreq)
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index d345b5a7aa71..5a782e35c2e9 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)	+= arm_big_little.o
 # LITTLE drivers, so that it is probed last.
 obj-$(CONFIG_ARM_DT_BL_CPUFREQ)		+= arm_big_little_dt.o
 
-obj-$(CONFIG_ARCH_DAVINCI_DA850)	+= davinci-cpufreq.o
+obj-$(CONFIG_ARCH_DAVINCI)		+= davinci-cpufreq.o
 obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)	+= exynos-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
-- 
1.9.1

