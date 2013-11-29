Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3K2D7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 22:59:44 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44763 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3K2D7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 22:59:38 -0500
Message-ID: <529811AE.8050502@gmail.com>
Date: Fri, 29 Nov 2013 12:01:50 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] arch: hexagon: kernel: hexagon_ksyms.c: export related
 symbols which various modules need
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need export all related functions and symbols for various modules with
allmodconfig. The related errors:

    MODPOST 2879 modules
  ERROR: "__vmyield" [sound/sound_firmware.ko] undefined!
  ERROR: "__phys_offset" [sound/drivers/snd-dummy.ko] undefined!
  ERROR: "ioremap_nocache" [drivers/char/ipmi/ipmi_si.ko] undefined!
  ERROR: "__iounmap" [drivers/char/ipmi/ipmi_si.ko] undefined!
  ...

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/kernel/hexagon_ksyms.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/hexagon/kernel/hexagon_ksyms.c b/arch/hexagon/kernel/hexagon_ksyms.c
index 32b1379..3188de4 100644
--- a/arch/hexagon/kernel/hexagon_ksyms.c
+++ b/arch/hexagon/kernel/hexagon_ksyms.c
@@ -20,6 +20,9 @@
 
 #include <asm/hexagon_vm.h>
 #include <asm/uaccess.h>
+#include <asm/io.h>
+#include <linux/dma-mapping.h>
+#include <asm/dma-mapping.h>
 
 EXPORT_SYMBOL(__copy_from_user_hexagon);
 EXPORT_SYMBOL(__copy_to_user_hexagon);
@@ -28,13 +31,29 @@ EXPORT_SYMBOL(__vmsetie);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 
+/* Additional functions */
+EXPORT_SYMBOL(__strnlen_user);
+EXPORT_SYMBOL(__vmyield);
+EXPORT_SYMBOL(__iounmap);
+EXPORT_SYMBOL(__clear_user_hexagon);
+EXPORT_SYMBOL(ioremap_nocache);
+EXPORT_SYMBOL(empty_zero_page);
+
+/* Additional variables */
+EXPORT_SYMBOL(_dflt_cache_att);
+EXPORT_SYMBOL(__phys_offset);
+EXPORT_SYMBOL(bad_dma_address);
+
 #define DECLARE_EXPORT(name)     \
 	extern void name(void); EXPORT_SYMBOL(name)
 
 /* Symbols found in libgcc that assorted kernel modules need */
 DECLARE_EXPORT(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes);
 
-DECLARE_EXPORT(__hexagon_divsi3);
-DECLARE_EXPORT(__hexagon_modsi3);
-DECLARE_EXPORT(__hexagon_udivsi3);
-DECLARE_EXPORT(__hexagon_umodsi3);
+DECLARE_EXPORT(__divsi3);
+DECLARE_EXPORT(__modsi3);
+DECLARE_EXPORT(__udivsi3);
+DECLARE_EXPORT(__umodsi3);
+
+/* Additional functions */
+DECLARE_EXPORT(csum_tcpudp_magic);
-- 
1.7.7.6
