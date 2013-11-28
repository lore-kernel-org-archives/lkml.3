Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3K1Mm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:42:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42184 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3K1Mmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:42:54 -0500
X-AuditID: cbfee61b-b7f166d000007a34-47-52973a4c790c
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3] cpufreq: exynos: Convert exynos-cpufreq to platform driver
Date: Thu, 28 Nov 2013 13:42:42 +0100
Message-id: <1385642562-9339-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381939238-30398-1-git-send-email-t.figa@samsung.com>
References: <1381939238-30398-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAV0fq+lBBttO6FlsnLGe1eJp0w92
	i8sLL7FanG16w27x5hG3xZuHmxktLu+aw2bxufcIo8WZ00DJk396GS3Wz3jNYrHxq4cDj8ed
	a3vYPNZNe8vsseVqO4tH35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZdxbtIS14L9MRWfXDcYG
	xicSXYycHBICJhLHD55khrDFJC7cW8/WxcjFISSwiFFi4cGJLBBOF5PE9ftHGEGq2AT0JD7f
	fcoEYosIhEocnfqVHaSIWWA3s8SK73vAEsICfhLLezeygtgsAqoS8w5cAYpzcPAKuEq8XcgB
	sU1e4un9PjaQMKeAs8SbxQogYSEBJ4n5m9ezTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjOASfSe9gXNVgcYhRgINRiYdXQmdakBBrYllxZe4hRgkOZiURXhf16UFCvCmJlVWp
	RfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGCvn6xhPCn5m53PSYRlz
	wsU1VzZt+vCDU+Z3flgop61OnBxj6f/94kfvsCz2+D0nZ0Hez/8Za3o3fmT3d2kItu1kfuQl
	s7FgYSDDI2nPh56xBoYRvtOfc8Y+YJKxOrhH4o2T8LeoyayXJq/a8+PNTl7nHSz1PBz811XP
	nl6ua/F/7n2Dvv6NWkosxRmJhlrMRcWJAMrlhn89AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the driver multiplatform-friendly, unconditional initialization
in an initcall is replaced with a platform driver probed only if
respective platform device is registered.

Tested at: Exynos4210 (TRATS) and Exynos4412 (TRATS2)

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
Changes for v3:
- Rename exynos_cpufreq_init() to exynos_cpufreq_probe()

Changes for v2:
- Proper definition of exynos_cpufreq_init() function to squash warnings

 arch/arm/mach-exynos/common.c          |    5 +++++
 arch/arm/mach-exynos/common.h          |    1 +
 arch/arm/mach-exynos/mach-exynos4-dt.c |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c |    1 +
 drivers/cpufreq/exynos-cpufreq.c       |   13 +++++++++++--
 5 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 61d2906..1510436 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -303,6 +303,11 @@ void __init exynos_cpuidle_init(void)
 	platform_device_register(&exynos_cpuidle);
 }
 
+void __init exynos_cpufreq_init(void)
+{
+	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
+}
+
 void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index ff9b6a9..3f03334 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -22,6 +22,7 @@ void exynos_init_io(void);
 void exynos4_restart(enum reboot_mode mode, const char *cmd);
 void exynos5_restart(enum reboot_mode mode, const char *cmd);
 void exynos_cpuidle_init(void);
+void exynos_cpufreq_init(void);
 void exynos_init_late(void);
 
 void exynos_firmware_init(void);
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 4603e6b..d3e54b7 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -22,6 +22,7 @@
 static void __init exynos4_dt_machine_init(void)
 {
 	exynos_cpuidle_init();
+	exynos_cpufreq_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index 1fe075a..602c5d7 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -44,6 +44,7 @@ static void __init exynos5_dt_machine_init(void)
 	}
 
 	exynos_cpuidle_init();
+	exynos_cpufreq_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index f3c2287..81b863c 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -17,6 +17,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/cpufreq.h>
 #include <linux/suspend.h>
+#include <linux/platform_device.h>
 
 #include <plat/cpu.h>
 
@@ -232,7 +233,7 @@ static struct cpufreq_driver exynos_driver = {
 #endif
 };
 
-static int __init exynos_cpufreq_init(void)
+static int exynos_cpufreq_probe(struct platform_device *pdev)
 {
 	int ret = -EINVAL;
 
@@ -281,4 +282,12 @@ err_vdd_arm:
 	kfree(exynos_info);
 	return -EINVAL;
 }
-late_initcall(exynos_cpufreq_init);
+
+static struct platform_driver exynos_cpufreq_platdrv = {
+	.driver = {
+		.name	= "exynos-cpufreq",
+		.owner	= THIS_MODULE,
+	},
+	.probe = exynos_cpufreq_probe,
+};
+module_platform_driver(exynos_cpufreq_platdrv);
-- 
1.7.10.4

