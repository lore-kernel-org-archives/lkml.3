Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbaJCWNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:13:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbaJCWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.14 118/238] MIPS: ZBOOT: add missing <linux/string.h> include
Date: Fri,  3 Oct 2014 14:30:33 -0700
Message-Id: <20141003212917.447893583@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

commit 29593fd5a8149462ed6fad0d522234facdaee6c8 upstream.

Commit dc4d7b37 (MIPS: ZBOOT: gather string functions into string.c)
moved the string related functions into a separate file, which might
cause the following build error, depending on the configuration:

| CC      arch/mips/boot/compressed/decompress.o
| In file included from linux/arch/mips/boot/compressed/../../../../lib/decompress_unxz.c:234:0,
|                  from linux/arch/mips/boot/compressed/decompress.c:67:
| linux/arch/mips/boot/compressed/../../../../lib/xz/xz_dec_stream.c: In function 'fill_temp':
| linux/arch/mips/boot/compressed/../../../../lib/xz/xz_dec_stream.c:162:2: error: implicit declaration of function 'memcpy' [-Werror=implicit-function-declaration]
| cc1: some warnings being treated as errors
| linux/scripts/Makefile.build:308: recipe for target 'arch/mips/boot/compressed/decompress.o' failed
| make[6]: *** [arch/mips/boot/compressed/decompress.o] Error 1
| linux/arch/mips/Makefile:308: recipe for target 'vmlinuz' failed

It does not fail with the standard configuration, as when
CONFIG_DYNAMIC_DEBUG is not enabled <linux/string.h> gets included in
include/linux/dynamic_debug.h. There might be other ways for it to
get indirectly included.

We can't add the include directly in xz_dec_stream.c as some
architectures might want to use a different version for the boot/
directory (see for example arch/x86/boot/string.h).

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7420/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/boot/compressed/decompress.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/boot/compressed/decompress.c
+++ b/arch/mips/boot/compressed/decompress.c
@@ -13,6 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/string.h>
 
 #include <asm/addrspace.h>
 


