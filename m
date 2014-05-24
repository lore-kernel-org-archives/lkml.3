Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaEXHJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:09:26 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58165 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaEXHJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:09:25 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 11/24] ARM64: Add ARM64_ILP32 to Kconfig.
Date: Sat, 24 May 2014 00:02:06 -0700
Message-Id: <1400914939-9708-12-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the config option for ILP32.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/Kconfig |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 032c712..92577da 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -288,7 +288,7 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	def_bool y
-	depends on AARCH32_EL0
+	depends on AARCH32_EL0 || ARM64_ILP32
 	select COMPAT_BINFMT_ELF
 
 config AARCH32_EL0
@@ -305,6 +305,13 @@ config AARCH32_EL0
 
 	  If you want to execute 32-bit userspace applications, say Y.
 
+config ARM64_ILP32
+	bool "Kernel support for ILP32"
+	help
+	  This option enables support for AArch64 ILP32 user space.  ILP32
+	  is an ABI where long and pointers are 32bits but it uses the AARCH64
+	  instruction set.
+
 config SYSVIPC_COMPAT
 	def_bool y
 	depends on AARCH32_EL0 && SYSVIPC
-- 
1.7.2.5

