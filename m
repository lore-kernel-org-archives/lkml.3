Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaDOB2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:28:12 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54846 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaDOB2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:28:10 -0400
X-Original-SENDERIP: 10.178.36.63
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chanho Min <chanho.min@lge.com>
Subject: [PATCH] arm64:kconfig: Add default line for CONFIG_COMPAT
Date: Tue, 15 Apr 2014 10:28:00 +0900
Message-Id: <1397525280-21844-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct minimal config is not generated without default line.
'default n' should be added to set COMPAT to 'n'. Otherwise,
Enabling COMPAT is not reflected to minial config.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 arch/arm64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..b891543 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -288,6 +288,7 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	bool "Kernel support for 32-bit EL0"
+	default n
 	depends on !ARM64_64K_PAGES
 	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
-- 
1.7.9.5

