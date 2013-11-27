Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab3K0XcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:32:16 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:49444 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab3K0XcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:32:13 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V5 5/6] Disable stack protection for decompressor/stub
Date: Wed, 27 Nov 2013 15:31:54 -0800
Message-Id: <1385595115-21488-6-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM decompressor/EFI stub do not implement the functions
(__stack_chk_guard_setup, etc) that are required for support of
stack protection.  The actual enablement of stack protection is
controlled by heuristics in GCC, which the code added for the EFI
stub triggers when CONFIG_STACKPROTECTOR is set.  Even with
CONFIG_STACKPROTECTOR set, the decompressor was never compiled
with stack protection actually enabled. Adding -fno-stack-protector
to the decompressor/stub build keeps it building without stack
protection as it has always been built.
The x86 decompressor/stub is also built with -fno-stack-protector.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/boot/compressed/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index c0c7fee..7974791 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -132,7 +132,7 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
-ccflags-y := -fpic -mno-single-pic-base -fno-builtin -I$(obj)
+ccflags-y := -fpic -mno-single-pic-base -fno-builtin -fno-stack-protector -I$(obj)
 asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
-- 
1.7.10.4

