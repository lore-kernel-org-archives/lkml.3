Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3DXDpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:45:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:3012 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab3DXDpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:45:16 -0400
X-Spam-Score: -100.8
Message-ID: <5177551D.8090007@asianux.com>
Date: Wed, 24 Apr 2013 11:44:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linaro-kernel@lists.linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm64: compiling issue, need add include/asm/vga.h file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For compiling with allmodconfig, need vga.h file, so copy it from arm32.

The related information:
  aarch64-linux-gnu-gcc -Wp,-MD,drivers/gpu/drm/.drm_irq.o.d  -nostdinc -isystem /usr/bin/../lib/gcc/aarch64-linux-gnu/4.7.3/include -I/root/linux-next/arch/arm64/include -Iarch/arm64/include/generated  -Iinclude -I/root/linux-next/arch/arm64/include/uapi -Iarch/arm64/include/generated/uapi -I/root/linux-next/include/uapi -Iinclude/generated/uapi -include /root/linux-next/include/linux/kconfig.h -D__KERNEL__ -mlittle-endian -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -Os -mgeneral-regs-only -fno-reorder-blocks -fno-ipa-cp-clone -fno-partial-inlining -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -femit-struct-debug-baseonly -fno-var-tracking -fno-inline-functions-called-once -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -DCC_HAV
 E_ASM_GOT
O -Iinclude/drm -W   -DMODULE  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(drm_irq)"  -D"KBUILD_MODNAME=KBUILD_STR(drm)" -c -o drivers/gpu/drm/.tmp_drm_irq.o drivers/gpu/drm/drm_irq.c

The related error:
include/video/vga.h: At top level:
include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
compilation terminated.
make[3]: *** [drivers/gpu/drm/drm_irq.o] Error 1
make[2]: *** [drivers/gpu/drm] Error 2
make[1]: *** [drivers/gpu] Error 2
make: *** [drivers] Error 2


Signed-off-by: root <root@dhcp122.asianux.net>
---
 arch/arm64/include/asm/vga.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 arch/arm64/include/asm/vga.h

diff --git a/arch/arm64/include/asm/vga.h b/arch/arm64/include/asm/vga.h
new file mode 100644
index 0000000..91f4021
--- /dev/null
+++ b/arch/arm64/include/asm/vga.h
@@ -0,0 +1,13 @@
+#ifndef ASMARM_VGA_H
+#define ASMARM_VGA_H
+
+#include <linux/io.h>
+
+extern unsigned long vga_base;
+
+#define VGA_MAP_MEM(x,s)	(vga_base + (x))
+
+#define vga_readb(x)	(*((volatile unsigned char *)x))
+#define vga_writeb(x,y)	(*((volatile unsigned char *)y) = (x))
+
+#endif
-- 
1.7.11.7
