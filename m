Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbaGOXlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:41:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933889AbaGOXOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.15 32/84] cpufreq: Makefile: fix compilation for davinci platform
Date: Tue, 15 Jul 2014 16:17:29 -0700
Message-Id: <20140715231714.166003701@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)	+=
 # LITTLE drivers, so that it is probed last.
 obj-$(CONFIG_ARM_DT_BL_CPUFREQ)		+= arm_big_little_dt.o
 
-obj-$(CONFIG_ARCH_DAVINCI_DA850)	+= davinci-cpufreq.o
+obj-$(CONFIG_ARCH_DAVINCI)		+= davinci-cpufreq.o
 obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)	+= exynos-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o


