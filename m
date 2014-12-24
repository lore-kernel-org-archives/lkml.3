Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaLXDQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:16:20 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:7425 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaLXDOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:14:00 -0500
From: Wang Long <long.wanglong@huawei.com>
To: <xuwei5@hisilicon.com>
CC: <arnd@arndb.de>, <yanhaifeng@gmail.com>, <zhangfei.gao@linaro.org>,
        <haojian.zhuang@linaro.org>, <khilman@linaro.org>,
        <lee.jones@linaro.org>, <linux@arm.linux.org.uk>,
        <long.wanglong@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peifeiyue@huawei.com>,
        <huxinwei@huawei.com>
Subject: [PATCH 1/7] ARM: debug: add HiP01 debug uart
Date: Wed, 24 Dec 2014 03:09:56 +0000
Message-ID: <1419390602-193123-2-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
References: <1419390602-193123-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.549A2F3B.0036,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 3e1854f0b912ea7066c37f1658ae61a9
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
index 5ddd490..e0cf6ce 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -272,6 +272,14 @@ choice
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
@@ -1252,6 +1260,7 @@ config DEBUG_UART_PHYS
 	default 0x16000000 if ARCH_INTEGRATOR
 	default 0x18000300 if DEBUG_BCM_5301X
 	default 0x1c090000 if DEBUG_VEXPRESS_UART0_RS1
+	default 0x20001000 if DEBUG_HIP01_UART
 	default 0x20060000 if DEBUG_RK29_UART0
 	default 0x20064000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 	default 0x20068000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
@@ -1394,6 +1403,7 @@ config DEBUG_UART_VIRT
 	default 0xfef36000 if DEBUG_HIGHBANK_UART
 	default 0xfefff700 if ARCH_IOP33X
 	default 0xff003000 if DEBUG_U300_UART
+	default 0xffd01000 if DEBUG_HIP01_UART
 	default DEBUG_UART_PHYS if !MMU
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
-- 
1.8.3.4

