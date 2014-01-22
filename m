Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaAVOVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:21:35 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23752 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbaAVOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:21:32 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-85-52dfd3ea2432
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RESEND] cpufreq: exynos: Fix build error of no type of
 module_init
Date: Wed, 22 Jan 2014 15:21:16 +0100
Message-id: <1390400476-22951-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xK7qvLt8PMjjdwWHxtOkHu8XrF4YW
	vQuuslmcbXrDbvHm4WZGi02Pr7FaXN41h83ic+8RRosZ5/cxWZw5fYnVYv2M1ywWG796OPB4
	3Lm2h81j85J6jy1X21k8+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+PiBOOCufwVry+dZGxg
	3MDbxcjJISFgInH76l52CFtM4sK99WxdjFwcQgJLGSV+Nu9hA0nwCghK/Jh8j6WLkYODWUBe
	4silbJAws4C6xKR5i5gh6vuYJGYuf8wMkmATMJbYvHwJ2CARgZlMEk/f7WEHcZgF1jBKTHzb
	ADZVWCBEovX2J1YQm0VAVaJ1Qz8LxDZ3iT8dP9hBtkkIKEjMmWQzgZFvFpI7ZiHcMQvJHQsY
	mVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihIT31x2MS49ZHWIU4GBU4uEN2HUvSIg1say4
	MvcQowQHs5IIr8eq+0FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGPtzjBtr/VnXvAkWP+PqXGb2
	ctXaJRfjdm+o8c/OvZz74MJOz8dn9FY6edoeuKN7dL/XdM5M66uSWvGTc8qz5N4f2qpav6n0
	xJEmKb9b3roZFgIPcwykbl5OO9WekJh+i91VPFxP41NDspwOmwhnXtxX5yfyr6TUv3/wyVB/
	bM/TfX3fb915SizFGYmGWsxFxYkAgM+5UE0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing include to fix build error:
drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_init’ [-Werror=implicit-int]
drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_exit’ [-Werror=implicit-int]
drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
drivers/cpufreq/exynos-cpufreq.c:292:1: warning: ‘exynos_cpufreq_platdrv_init’ defined but not used [-Wunused-function]
cc1: some warnings being treated as errors
make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1
make[1]: *** [drivers/cpufreq] Error 2

Build error happens on gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
and was introduced by commit d568b6f71df1 (cpufreq: exynos: Convert
exynos-cpufreq to platform driver).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index fcd2914d081a..fa54c2b88dd7 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -17,6 +17,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/cpufreq.h>
 #include <linux/suspend.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 
 #include <plat/cpu.h>
-- 
1.7.9.5

