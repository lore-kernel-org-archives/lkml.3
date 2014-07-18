Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030821AbaGRNSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:11 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17939 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422673AbaGRNSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 148/170] cpufreq: Makefile: fix compilation for davinci platform
Date: Fri, 18 Jul 2014 14:12:33 +0200
Message-Id: <e3a192bd0b56eb15e9a0376f7921c68d15cf2016.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prabhakar Lad <prabhakar.csengg@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/cpufreq/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index ad5866c2ada0..c2df33ba23c2 100644
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
2.0.0

