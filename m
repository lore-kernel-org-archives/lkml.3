Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaDAKSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:18:55 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55838 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAKSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:18:53 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Laura Abbott <lauraa@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if CONFIG_JUMP_LABEL is enabled
Date: Tue,  1 Apr 2014 12:04:17 +0200
Message-Id: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_SET_MODULE_RONX sounds like a nice security feature, but
things might fail late (and unexpected) if module code is set to read-only
while CONFIG_JUMP_LABEL is enabled (e.g. modprobe bridge).

Avoid this.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/arm/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 0531da8..6627b9e 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1197,7 +1197,7 @@ config PID_IN_CONTEXTIDR
 
 config DEBUG_SET_MODULE_RONX
 	bool "Set loadable kernel module data as NX and text as RO"
-	depends on MODULES
+	depends on MODULES && !JUMP_LABEL
 	---help---
 	  This option helps catch unintended modifications to loadable
 	  kernel module's text and read-only data. It also prevents execution
-- 
1.8.3.1

