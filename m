Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3I1QXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 12:23:47 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:39403 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3I1QXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 12:23:12 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 5/6] Disable stack protection for decompressor/stub
Date: Sat, 28 Sep 2013 09:23:22 -0700
Message-Id: <1380385403-31904-6-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM decompressor/EFI stub do not implement the functions
(__stack_chk_guard_setup, etc) that are required for support of
stack protection.  The actual enablement of stack protection is
controlled by heuristics in GCC, which the code added for the EFI
stub triggers when CONFIG_STACKPROTECTOR is set.  Even with
CONFIG_STACKPROTECTOR set, the decompressor was not compiled
with stack protection actually enabled. Adding -fno-stack-protector
to the decompressor/stub build keeps it building without stack
protection as it has always been built.
The x86 decompressor/stub is also build with -fno-stack-protector.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/boot/compressed/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 5fad8bd..551dbf9 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -136,7 +136,7 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
-ccflags-y := -fpic -mno-single-pic-base -fno-builtin -I$(obj)
+ccflags-y := -fpic -mno-single-pic-base -fno-builtin -fno-stack-protector -I$(obj)
 asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
-- 
1.7.10.4

