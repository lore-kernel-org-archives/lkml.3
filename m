Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaDNIIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:08:09 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:58821 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaDNIIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:08:02 -0400
X-Original-SENDERIP: 10.178.36.63
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chanho Min <chanho.min@lge.com>
Subject: [PATCH] arm64:kconfig: make default for CONFIG_COMPAT
Date: Mon, 14 Apr 2014 17:08:03 +0900
Message-Id: <1397462883-12740-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make savedefconfig' doesn't generate defconfig properly due to
missing COMPAT default. So Add default and set to yes.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 4907b85..93b7531 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -294,6 +294,7 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	bool "Kernel support for 32-bit EL0"
+	default y
 	depends on !ARM64_64K_PAGES
 	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
-- 
1.7.9.5

