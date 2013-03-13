Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab3CMVKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:10:09 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:63717 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab3CMVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:10:08 -0400
Message-ID: <1363209002.1335.12.camel@x61.thuisdomein>
Subject: [PATCH] PM: devfreq: fix typo "CPU_EXYNOS4.12" twice
From: Paul Bolle <pebolle@tiscali.nl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 22:10:02 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2013 21:10:03.0377 (UTC) FILETIME=[2140CE10:01CE202F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dependencies on CPU_EXYNOS4212 and CPU_EXYNOS4412 for the "ARM
Exynos4210/4212/4412 Memory Bus DEVFREQ Driver" were added in commit
7b4050381127ae11fcfc74a106d715a5fbbf888a ("PM/Devfreq: Add Exynos4-bus
device DVFS driver for Exynos4210/4212/4412."). The tree (at that time,
v3.3, and currently) makes clear that this should have been dependencies
on SOC_EXYNOS4212 and SOC_EXYNOS4412.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/devfreq/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 0f079be..0ec6572 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -67,7 +67,7 @@ comment "DEVFREQ Drivers"
 
 config ARM_EXYNOS4_BUS_DEVFREQ
 	bool "ARM Exynos4210/4212/4412 Memory Bus DEVFREQ Driver"
-	depends on CPU_EXYNOS4210 || CPU_EXYNOS4212 || CPU_EXYNOS4412
+	depends on CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412
 	select ARCH_HAS_OPP
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	help
-- 
1.7.11.7

