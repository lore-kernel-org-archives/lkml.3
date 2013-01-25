Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3AYMdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:33:36 -0500
Received: from zmc.proxad.net ([212.27.53.206]:35567 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049Ab3AYMdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:33:24 -0500
From: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org
Cc: lasse.collin@tukaani.org, akpm@linux-foundation.org,
        Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 1/3] decompressors: group XZ_DEC_* symbols under an if XZ_BCJ / endif
Date: Fri, 25 Jan 2013 13:30:34 +0100
Message-Id: <1359117036-25064-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358266931-23401-1-git-send-email-florian@openwrt.org>
References: <1358266931-23401-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch groups all architecture-specific BCJ filter configuration
symbols under an if XZ_BCJ / endif statement.

Acked-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 lib/xz/Kconfig |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/lib/xz/Kconfig b/lib/xz/Kconfig
index 60a6088..12d2d777 100644
--- a/lib/xz/Kconfig
+++ b/lib/xz/Kconfig
@@ -6,42 +6,40 @@ config XZ_DEC
 	  the .xz file format as the container. For integrity checking,
 	  CRC32 is supported. See Documentation/xz.txt for more information.
 
+if XZ_DEC
+
 config XZ_DEC_X86
 	bool "x86 BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
 	bool "PowerPC BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
 	bool "IA-64 BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
 	bool "ARM BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
 	bool "ARM-Thumb BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
 	bool "SPARC BCJ filter decoder" if EXPERT
 	default y
-	depends on XZ_DEC
 	select XZ_DEC_BCJ
 
+endif
+
 config XZ_DEC_BCJ
 	bool
 	default n
-- 
1.7.10.4

