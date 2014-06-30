Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaF3Lbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:31:41 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58168 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaF3Lbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:31:38 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v7 4/4] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Mon, 30 Jun 2014 12:30:55 +0100
Message-Id: <1404127855-30459-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
References: <1401206421-29832-1-git-send-email-daniel.thompson@linaro.org>
 <1404127855-30459-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a multi_v7_defconfig kernel it is not possible to configure
DEBUG_LL to use any serial device except a ARM Primecell PL01X, or more
accurately and worse, it is possible to configure a different serial
device but KConfig does not honour this request. In fact this also
overrides the user selection for some of the single platform kernels, for
example I don't think DEBUG_LL can be targetted at ICE or semihosted
supervisor for ARCH_VERSATILE.

This happens because DEBUG_UART_PL01X is automatically enabled by
some architectures and this means user decisions made regarding
the DEBUG_LL backend will be overriden. Problem is fixed by removing the
automatic enabling of this option.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/Kconfig.debug | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 459c7f9..26536f7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1032,12 +1032,7 @@ config DEBUG_LL_INCLUDE
 
 # Compatibility options for PL01x
 config DEBUG_UART_PL01X
-	def_bool ARCH_EP93XX || \
-		ARCH_INTEGRATOR || \
-		ARCH_SPEAR3XX || \
-		ARCH_SPEAR6XX || \
-		ARCH_SPEAR13XX || \
-		ARCH_VERSATILE
+	bool
 
 # Compatibility options for 8250
 config DEBUG_UART_8250
-- 
1.9.3

