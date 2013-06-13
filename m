Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3FMNLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:11:46 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:52124 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3FMNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:11:14 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>
Cc: David McCullough <david_mccullough@au.securecomputing.com>,
        Thorsten Glaser <tg@mirbsd.org>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] ARM: shmobile: Use POSIX "$((..))" instead of bashism "$[...]"
Date: Thu, 13 Jun 2013 15:10:51 +0200
Message-Id: <1371129052-31506-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
References: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the bash 4.1 manpage, "$[...]" is deprecated, and will be
removed in upcoming versions of bash.
Hence replace the bash-specific "$[...]" by POSIX "$((..))" for arithmetic
expansion, which also allows to drop the forced use of bash.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/arm/mach-shmobile/Makefile.boot |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/Makefile.boot b/arch/arm/mach-shmobile/Makefile.boot
index 95ebc7c..75a55e1 100644
--- a/arch/arm/mach-shmobile/Makefile.boot
+++ b/arch/arm/mach-shmobile/Makefile.boot
@@ -1,5 +1,5 @@
-__ZRELADDR	:= $(shell /bin/bash -c 'printf "0x%08x" \
-		     $$[$(CONFIG_MEMORY_START) + 0x8000]')
+__ZRELADDR	:= $(shell printf "0x%08x" \
+		     $$(($(CONFIG_MEMORY_START) + 0x8000)))
 
    zreladdr-y   += $(__ZRELADDR)
 
-- 
1.7.0.4

