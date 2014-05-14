Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaENIFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:05:22 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59701 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaENIEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:04:38 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <chander.kashyap@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>
Subject: [PATCH v5 5/6] exynos: cpuidle: do not allow cpuidle registration for Exynos5420
Date: Wed, 14 May 2014 13:33:56 +0530
Message-Id: <1400054637-21505-6-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com>
 <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5420 is big.Little Soc. It uses cpuidle-big-litle generic cpuidle driver.
Hence do not allow exynos cpuidle driver registration for Exynos5420.

Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-exynos/cpuidle.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
index 3dd385e..807a386 100644
--- a/arch/arm/mach-exynos/cpuidle.c
+++ b/arch/arm/mach-exynos/cpuidle.c
@@ -218,6 +218,9 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
 	int cpu_id, ret;
 	struct cpuidle_device *device;
 
+	if (soc_is_exynos5420())
+		return -ENODEV;
+
 	if (soc_is_exynos5250())
 		exynos5_core_down_clk();
 
-- 
1.7.9.5

