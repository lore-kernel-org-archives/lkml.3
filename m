Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab3K1LgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:36:05 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42542 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab3K1LgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:36:01 -0500
X-AuditID: cbfee61b-b7f166d000007a34-5a-52972aa00102
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
Subject: [PATCH v2] cpufreq: exynos: Convert exynos-cpufreq to platform driver
Date: Thu, 28 Nov 2013 12:35:47 +0100
Message-id: <1385638547-2974-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381939238-30398-1-git-send-email-t.figa@samsung.com>
References: <1381939238-30398-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jAd0FWtODDF6ckrPYOGM9q8XTph/s
	FpcXXmK1ONv0ht3izSNuizcPNzNaXN41h83ic+8RRoszp4GSJ//0Mlqsn/GaxWLjVw8HHo87
	1/aweayb9pbZY8vVdhaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyrh/+yVLwQaZitZf91ka
	GBdKdDFyckgImEjMXfyJBcIWk7hwbz1bFyMXh5DAIkaJYz3PWCCcLiaJi1eWgVWxCehJfL77
	lAnEFhEIlTg69Ss7SBGzwG5miRXf94AlhAX8JC6tesAMYrMIqEp8uj6BHcTmFXCV2Hh+GyPE
	OnmJp/f7gNZxcHAKOEu8WawAEhYScJKYv3k96wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxgoPwmfQOxlUNFocYBTgYlXh4JXSmBQmxJpYVV+YeYpTgYFYS4XVRnx4kxJuSWFmV
	WpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJg1OqgTH58T/5z9xsP4V09KWu
	BhR2vGZ4YmrC1VURlFAjE1N8ZeoeBv9foT0NiluVVGf+F+87lf8gq5AvyWDl49PFRxS+WZmv
	Pnc0WF2I7fq74N8st1SLbbquM/xcfm1uxt1tyekLDxcs/8uUVDqDNeHtyhtcjalS0dLvq/m8
	pr4usNfJfDk3/lWYiBJLcUaioRZzUXEiALN6JEo+AgAA
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
index f3c2287..e238c46 100644
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
+static int exynos_cpufreq_init(struct platform_device *pdev)
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
+	.probe = exynos_cpufreq_init,
+};
+module_platform_driver(exynos_cpufreq_platdrv);
-- 
1.7.10.4

