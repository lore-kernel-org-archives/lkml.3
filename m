Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaFJJ52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:57:28 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59184 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaFJJ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:57:26 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] ARM: debug: fix broken DEBUG_LL_INCLUDE for multi platform
Date: Tue, 10 Jun 2014 10:57:16 +0100
Message-Id: <1402394236-14778-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On multi_v7_defconfig using def_bool in Kconfig can override the selection
made as part of DEBUG_LL. This is because def_bool will set the config to true
if the expression evaluates to true, which is what was happening in
multi_v7_defconfig. ARCH_SPEAR13XX selects DEBUG_UART_PL01X overiding any
previous DEBUG_LL selections.

Making the def_bool to bool and depends made sense in this case, and
fixes the issue too.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8f90595..53d653c1 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1021,7 +1021,8 @@ config DEBUG_LL_INCLUDE
 
 # Compatibility options for PL01x
 config DEBUG_UART_PL01X
-	def_bool ARCH_EP93XX || \
+	bool
+	depends on ARCH_EP93XX || \
 		ARCH_INTEGRATOR || \
 		ARCH_SPEAR3XX || \
 		ARCH_SPEAR6XX || \
-- 
1.9.1

