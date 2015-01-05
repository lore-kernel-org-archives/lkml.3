Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbbAEMky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:40:54 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46750 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbAEMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:40:52 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 3.19-rc2 v15 2/8] arm: configs: Enable DEBUG_LL_UART_8250 where needed
Date: Mon,  5 Jan 2015 12:40:18 +0000
Message-Id: <1420461624-4410-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420461624-4410-1-git-send-email-daniel.thompson@linaro.org>
References: <1420461624-4410-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All defconfigs touched by this patch already enable DEBUG_LL and by
default DEBUG_LL_UART_NONE will be selected. This causes no issues
today because due to some back compatibility magic we eventually need
to remove it is not actually honoured. Nevertheless DEBUG_LL_UART_8250
is the right value for these platforms and should be set in the config
files.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/configs/iop32x_defconfig  | 1 +
 arch/arm/configs/iop33x_defconfig  | 1 +
 arch/arm/configs/ixp4xx_defconfig  | 1 +
 arch/arm/configs/lpc32xx_defconfig | 1 +
 arch/arm/configs/mv78xx0_defconfig | 1 +
 arch/arm/configs/orion5x_defconfig | 1 +
 arch/arm/configs/rpc_defconfig     | 1 +
 7 files changed, 7 insertions(+)

diff --git a/arch/arm/configs/iop32x_defconfig b/arch/arm/configs/iop32x_defconfig
index 4f2ec3ac138e..c3058da631da 100644
--- a/arch/arm/configs/iop32x_defconfig
+++ b/arch/arm/configs/iop32x_defconfig
@@ -106,6 +106,7 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_KEYS=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
 CONFIG_CRYPTO_NULL=y
diff --git a/arch/arm/configs/iop33x_defconfig b/arch/arm/configs/iop33x_defconfig
index aa36128abca2..713faeee8cf4 100644
--- a/arch/arm/configs/iop33x_defconfig
+++ b/arch/arm/configs/iop33x_defconfig
@@ -87,5 +87,6 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 # CONFIG_CRC32 is not set
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
index 1af665e847d1..24636cfdf6df 100644
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -202,3 +202,4 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_ERRORS=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
index 9f56ca3985ae..c100b7df5441 100644
--- a/arch/arm/configs/lpc32xx_defconfig
+++ b/arch/arm/configs/lpc32xx_defconfig
@@ -204,6 +204,7 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_FTRACE is not set
 # CONFIG_ARM_UNWIND is not set
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_CRYPTO_ANSI_CPRNG=y
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 0dae1c1f007a..85d10d2e3d66 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -132,6 +132,7 @@ CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
diff --git a/arch/arm/configs/orion5x_defconfig b/arch/arm/configs/orion5x_defconfig
index 952430d9e2d9..855143fac6bd 100644
--- a/arch/arm/configs/orion5x_defconfig
+++ b/arch/arm/configs/orion5x_defconfig
@@ -156,6 +156,7 @@ CONFIG_LATENCYTOP=y
 # CONFIG_FTRACE is not set
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
 CONFIG_CRYPTO_CBC=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
diff --git a/arch/arm/configs/rpc_defconfig b/arch/arm/configs/rpc_defconfig
index 00515ef9782d..89631795a915 100644
--- a/arch/arm/configs/rpc_defconfig
+++ b/arch/arm/configs/rpc_defconfig
@@ -131,3 +131,4 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_USER=y
 CONFIG_DEBUG_ERRORS=y
 CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
-- 
1.9.3

