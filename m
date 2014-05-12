Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaELImo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:42:44 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5141 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753882AbaELImn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:42:43 -0400
From: Qiang Chen <qiang2.chen@sonymobile.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <qcwj.lk@gmail.com>
Subject: [PATCH] ARM: decompressor: disable branch profiling
Date: Mon, 12 May 2014 16:42:13 +0800
Message-ID: <1399884133-2311-1-git-send-email-qiang2.chen@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early kernel decrompressing code can't call into the kernel
in order to profile branches. This patch fixes below link error:

arch/arm/boot/compressed/decompress.o: In function `lzo1x_decompress_safe':
undefined reference to `ftrace_likely_update'

Signed-off-by: Qiang Chen <qiang2.chen@sonymobile.com>
---
 arch/arm/boot/compressed/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 68c9183..384c843 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -120,6 +120,7 @@ ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
+KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 
 ccflags-y := -fpic -mno-single-pic-base -fno-builtin -I$(obj)
 asflags-y := -DZIMAGE
-- 
1.8.2.2

