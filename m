Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaAVOSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:18:47 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11843 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaAVOSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:18:41 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f796d000005a13-a4-52dfd33ed0f1
Content-transfer-encoding: 8BIT
From: y@samsung.com
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] cpufreq: exynos: Fix build error of no type of module_init
Date: Wed, 22 Jan 2014 15:18:29 +0100
Message-id: <1390400309-22806-1-git-send-email-y@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <y@samsung.com>
References: <y@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xq7p2l+8HGUxq4Ld42vSD3eL1C0OL
	3gVX2SzONr1ht3jzcDOjxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqsX7GaxaLjV89HHg8
	7lzbw+axeUm9x5ar7SwefVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlfHr4wf2giv8FX3v/jA3
	MD7g7WLk5JAQMJE4/OQpE4QtJnHh3nq2LkYuDiGBpYwS+38/ZwZJ8AoISvyYfI+li5GDg1lA
	XuLIpWyQMLOAusSkeYuYIer7mCSWLTnDDFLDJiAsMfWAFkhcRGAmk8TTd3vYQRxmgTWMEhPf
	NrCBdAsLeEtM23kWbDOLgKrEn9bZUMtsJVadnMEKMkhCQEFiziQbkDCngIzEnNmr2EFsIQFp
	ifvdPSwTGAVmITlvFsJ5s5Cct4CReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSDx82cG4
	+JjVIUYBDkYlHt7AXfeChFgTy4orcw8xSnAwK4nweqy6HyTEm5JYWZValB9fVJqTWnyIkYmD
	U6qBUeKj7/35k7rkfT3Nu5OeCz46vqdNdvOynca7dJ59mfPgj/B212pDc7EZtv6tqxXiP3+1
	jJl55HRA9tzTESGPfIRk1SK+GR5/o3f/c4xy4YIXam//b7QM7l/Xc+FH8cEt/1n/PG194e4z
	nWHDntXtKd385tuDLhxgnuvFFVGyVXxabrr6W/sbPkosxRmJhlrMRcWJAI8sqAZlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

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

