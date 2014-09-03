Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaICVXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:23:11 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53956 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbaICVXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:23:08 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 23/24] ARM64: Add ARM64_ILP32 to Kconfig
Date: Wed,  3 Sep 2014 14:19:17 -0700
Message-Id: <1409779158-30963-24-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the config option for ILP32.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/Kconfig |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 73c93dd..4ee4183 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -376,7 +376,7 @@ source "fs/Kconfig.binfmt"
 
 config COMPAT
 	def_bool y
-	depends on AARCH32_EL0
+	depends on AARCH32_EL0 || ARM64_ILP32
 	select COMPAT_BINFMT_ELF
 
 config AARCH32_EL0
@@ -393,6 +393,13 @@ config AARCH32_EL0
 
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

