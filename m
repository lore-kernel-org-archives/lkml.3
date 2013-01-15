Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3AOQZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:25:03 -0500
Received: from zmc.proxad.net ([212.27.53.206]:34447 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3AOQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:25:01 -0500
From: Florian Fainelli <florian@openwrt.org>
To: lasse.collin@tukaani.org
Cc: linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 2/2] decompressors: make the default XZ_BCJ_* config match the selected architecture
Date: Tue, 15 Jan 2013 17:22:10 +0100
Message-Id: <1358266931-23401-2-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358266931-23401-1-git-send-email-florian@openwrt.org>
References: <1358266931-23401-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the defautl XZ_BCJ_* config symbol to match the
configured architecture. It is perfectly legitimate to support multiple
XZ BCJ filters for different architectures (e.g.: to mount foreign
squashfs/xz compressed filesystems), it is however more natural not to
select them all by default, but only the one matching the configured
architecture.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 lib/xz/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/xz/Kconfig b/lib/xz/Kconfig
index 12d2d777..90264dd 100644
--- a/lib/xz/Kconfig
+++ b/lib/xz/Kconfig
@@ -10,32 +10,32 @@ if XZ_DEC
 
 config XZ_DEC_X86
 	bool "x86 BCJ filter decoder" if EXPERT
-	default y
+	default y if X86
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
 	bool "PowerPC BCJ filter decoder" if EXPERT
-	default y
+	default y if POWERPC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
 	bool "IA-64 BCJ filter decoder" if EXPERT
-	default y
+	default y if IA64
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
 	bool "ARM BCJ filter decoder" if EXPERT
-	default y
+	default y if ARM
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
 	bool "ARM-Thumb BCJ filter decoder" if EXPERT
-	default y
+	default y if (ARM && ARM_THUMB)
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
 	bool "SPARC BCJ filter decoder" if EXPERT
-	default y
+	default y if SPARC64
 	select XZ_DEC_BCJ
 
 endif
-- 
1.7.10.4

