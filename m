Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3FMNLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:11:18 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:36030 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3FMNLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:11:13 -0400
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
Subject: [PATCH 1/3] h8300/boot: Use POSIX "$((..))" instead of bashism "$[...]"
Date: Thu, 13 Jun 2013 15:10:50 +0200
Message-Id: <1371129052-31506-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
References: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Ubuntu, where /bin/sh -> dash, "make ARCH=h8300 clean" gives:

printf: 1: $[0x00400000+0x00140000]: expected numeric value

Replace the bash-specific "$[...]" by POSIX "$((..))" for arithmetic
expansion to fix this.
Note that according to the bash 4.1 manpage, "$[...]" is deprecated, and
will be removed in upcoming versions of bash.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/boot/compressed/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/boot/compressed/Makefile b/arch/h8300/boot/compressed/Makefile
index 94faad1..787fd04 100644
--- a/arch/h8300/boot/compressed/Makefile
+++ b/arch/h8300/boot/compressed/Makefile
@@ -16,7 +16,7 @@ OBJECTS = $(obj)/head.o $(obj)/misc.o
 #
 CONFIG_MEMORY_START     ?= 0x00400000
 CONFIG_BOOT_LINK_OFFSET ?= 0x00140000
-IMAGE_OFFSET := $(shell printf "0x%08x" $$[$(CONFIG_MEMORY_START)+$(CONFIG_BOOT_LINK_OFFSET)])
+IMAGE_OFFSET := $(shell printf "0x%08x" $$(($(CONFIG_MEMORY_START)+$(CONFIG_BOOT_LINK_OFFSET))))
 
 LDFLAGS_vmlinux := -Ttext $(IMAGE_OFFSET) -estartup $(obj)/vmlinux.lds
 
-- 
1.7.0.4

