Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaK1CWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:22:55 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48742 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaK1CVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:21:52 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>, <arnd@arndb.de>, <yanhaifeng@gmail.com>,
        <zhangfei.gao@linaro.org>, <haojian.zhuang@linaro.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <jason@lakedaemon.net>, <jh80.chung@samsung.com>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <mark.rutland@arm.com>,
        <maxime.ripard@free-electrons.com>, <obh+dt@kernel.org>,
        <olof@lixom.net>, <pawel.moll@arm.com>, <swarren@nvidia.com>,
        <thomas.petazzoni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 2/7] ARM: hisi: enable HiP01 SoC
Date: Fri, 28 Nov 2014 02:15:45 +0000
Message-ID: <1417140950-67103-3-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
References: <1417140950-67103-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable Hisilicon HiP01 SoC. This HiP01 SoC series support both
one core or dual cores and quad cores. The core is Cortex A9.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/mach-hisi/Kconfig     |  8 ++++++++
 arch/arm/mach-hisi/hisilicon.c | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/mach-hisi/Kconfig b/arch/arm/mach-hisi/Kconfig
index cd19433..83061ad 100644
--- a/arch/arm/mach-hisi/Kconfig
+++ b/arch/arm/mach-hisi/Kconfig
@@ -22,6 +22,14 @@ config ARCH_HI3xxx
 	help
 	  Support for Hisilicon Hi36xx SoC family
 
+config ARCH_HIP01
+       bool "Hisilicon HIP01 family" if ARCH_MULTI_V7
+       select HAVE_ARM_SCU if SMP
+       select HAVE_ARM_TWD if SMP
+       select ARM_GLOBAL_TIMER
+       help
+         Support for Hisilicon HIP01 SoC family
+
 config ARCH_HIP04
 	bool "Hisilicon HiP04 Cortex A15 family" if ARCH_MULTI_V7
 	select ARM_ERRATA_798181 if SMP
diff --git a/arch/arm/mach-hisi/hisilicon.c b/arch/arm/mach-hisi/hisilicon.c
index 7744c35..76b9070 100644
--- a/arch/arm/mach-hisi/hisilicon.c
+++ b/arch/arm/mach-hisi/hisilicon.c
@@ -72,3 +72,13 @@ static const char *hip04_compat[] __initconst = {
 DT_MACHINE_START(HIP04, "Hisilicon HiP04 (Flattened Device Tree)")
 	.dt_compat	= hip04_compat,
 MACHINE_END
+
+static const char *hip01_compat[] __initconst = {
+	"hisilicon,hip01",
+	"hisilicon,hip01-ca9x2",
+	NULL,
+};
+
+DT_MACHINE_START(HIP01, "Hisilicon HIP01 (Flattened Device Tree)")
+	.dt_compat      = hip01_compat,
+MACHINE_END
-- 
1.8.3.4

