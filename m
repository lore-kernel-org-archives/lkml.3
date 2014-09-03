Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbaICVTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:19:34 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55278 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbaICVT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 02/24] ARM64: Rename COMPAT to AARCH32_EL0 in Kconfig
Date: Wed,  3 Sep 2014 14:18:56 -0700
Message-Id: <1409779158-30963-3-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to split CONFIG_COMPAT so we can use the COMPAT interface in some cases including
for compat binfmt.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/Kconfig |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a..73c93dd 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -375,9 +375,13 @@ menu "Userspace binary formats"
 source "fs/Kconfig.binfmt"
 
 config COMPAT
+	def_bool y
+	depends on AARCH32_EL0
+	select COMPAT_BINFMT_ELF
+
+config AARCH32_EL0
 	bool "Kernel support for 32-bit EL0"
 	depends on !ARM64_64K_PAGES
-	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
 	select OLD_SIGSUSPEND3
 	select COMPAT_OLD_SIGACTION
@@ -391,7 +395,7 @@ config COMPAT
 
 config SYSVIPC_COMPAT
 	def_bool y
-	depends on COMPAT && SYSVIPC
+	depends on AARCH32_EL0 && SYSVIPC
 
 endmenu
 
-- 
1.7.2.5

