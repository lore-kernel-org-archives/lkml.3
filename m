Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaK1CVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:21:48 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:48714 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaK1CVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:21:45 -0500
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
Subject: [PATCH 1/7] ARM: debug: add HiP01 debug uart
Date: Fri, 28 Nov 2014 02:15:44 +0000
Message-ID: <1417140950-67103-2-git-send-email-long.wanglong@huawei.com>
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

Add the support of Hisilicon HiP01 debug uart.
The uart of hip01 is 8250 compatible.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/Kconfig.debug | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index d8f6a2e..ab65e58 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -240,6 +240,14 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to the UART on Highbank based devices.
 
+	config DEBUG_HIP01_UART
+		bool "Hisilicon Hip01 Debug UART"
+		depends on ARCH_HIP01
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on HIP01 UART.
+
 	config DEBUG_HIP04_UART
 		bool "Hisilicon HiP04 Debug UART"
 		depends on ARCH_HIP04
@@ -1117,6 +1125,7 @@ config DEBUG_UART_PHYS
 	default 0x16000000 if ARCH_INTEGRATOR
 	default 0x18000300 if DEBUG_BCM_5301X
 	default 0x1c090000 if DEBUG_VEXPRESS_UART0_RS1
+	default 0x20001000 if DEBUG_HIP01_UART
 	default 0x20060000 if DEBUG_RK29_UART0
 	default 0x20064000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 	default 0x20068000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
@@ -1240,6 +1249,7 @@ config DEBUG_UART_VIRT
 	default 0xfef36000 if DEBUG_HIGHBANK_UART
 	default 0xfefff700 if ARCH_IOP33X
 	default 0xff003000 if DEBUG_U300_UART
+	default 0xffd01000 if DEBUG_HIP01_UART
 	default DEBUG_UART_PHYS if !MMU
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
-- 
1.8.3.4

