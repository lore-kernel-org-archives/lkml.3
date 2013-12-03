Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3LCM0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:26:51 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62365 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3LCM0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:26:49 -0500
Message-ID: <529DCE06.3040508@gmail.com>
Date: Tue, 03 Dec 2013 20:26:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] arch: hexagon: kernel: hexagon_ksyms.c: export related
 symbols which various modules need
References: <529811AE.8050502@gmail.com> <20131203011222.GA23175@codeaurora.org>
In-Reply-To: <20131203011222.GA23175@codeaurora.org>
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

For including files, need "linux/*" first, then "asm/*". All related
included files and symbols need be sorted by alphabetical order.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/kernel/hexagon_ksyms.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/hexagon/kernel/hexagon_ksyms.c b/arch/hexagon/kernel/hexagon_ksyms.c
index 32b1379..c041d8e 100644
--- a/arch/hexagon/kernel/hexagon_ksyms.c
+++ b/arch/hexagon/kernel/hexagon_ksyms.c
@@ -18,23 +18,39 @@
  * 02110-1301, USA.
  */
 
+#include <linux/dma-mapping.h>
 #include <asm/hexagon_vm.h>
+#include <asm/io.h>
 #include <asm/uaccess.h>
 
+/* Additional functions */
+EXPORT_SYMBOL(__clear_user_hexagon);
 EXPORT_SYMBOL(__copy_from_user_hexagon);
 EXPORT_SYMBOL(__copy_to_user_hexagon);
+EXPORT_SYMBOL(__iounmap);
+EXPORT_SYMBOL(__strnlen_user);
 EXPORT_SYMBOL(__vmgetie);
 EXPORT_SYMBOL(__vmsetie);
+EXPORT_SYMBOL(__vmyield);
+EXPORT_SYMBOL(empty_zero_page);
+EXPORT_SYMBOL(ioremap_nocache);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 
+/* Additional variables */
+EXPORT_SYMBOL(__phys_offset);
+EXPORT_SYMBOL(_dflt_cache_att);
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
+/* Additional functions */
+DECLARE_EXPORT(__divsi3);
+DECLARE_EXPORT(__modsi3);
+DECLARE_EXPORT(__udivsi3);
+DECLARE_EXPORT(__umodsi3);
+DECLARE_EXPORT(csum_tcpudp_magic);
-- 
1.7.11.7
