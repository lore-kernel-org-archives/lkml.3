Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3J1Ddz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:33:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:12820 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3J1Ddy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:33:54 -0400
X-Spam-Score: -100.8
Message-ID: <526DDAE5.9040803@asianux.com>
Date: Mon, 28 Oct 2013 11:32:53 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, noamc@ezchip.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: kernel: use exporting symbol instead of static inline
 for arc_get_core_freq()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need export arc_get_core_freq() instead of let it static inline, or if
other individual modules use it (e.g. use BASE_BAUD), it can not find
core_freq variable.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/clk.h |    9 +--------
 arch/arc/kernel/clk.c      |    9 ++++++++-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arc/include/asm/clk.h b/arch/arc/include/asm/clk.h
index bf9d29f..256321a 100644
--- a/arch/arc/include/asm/clk.h
+++ b/arch/arc/include/asm/clk.h
@@ -9,14 +9,7 @@
 #ifndef _ASM_ARC_CLK_H
 #define _ASM_ARC_CLK_H
 
-/* Although we can't really hide core_freq, the accessor is still better way */
-extern unsigned long core_freq;
-
-static inline unsigned long arc_get_core_freq(void)
-{
-	return core_freq;
-}
-
+extern unsigned long arc_get_core_freq(void);
 extern int arc_set_core_freq(unsigned long);
 
 #endif
diff --git a/arch/arc/kernel/clk.c b/arch/arc/kernel/clk.c
index 10c7b0b..9f4602f 100644
--- a/arch/arc/kernel/clk.c
+++ b/arch/arc/kernel/clk.c
@@ -6,9 +6,16 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <asm/clk.h>
 
-unsigned long core_freq = 80000000;
+static unsigned long core_freq = 80000000;
+
+unsigned long arc_get_core_freq(void)
+{
+	return core_freq;
+}
+EXPORT_SYMBOL_GPL(arc_get_core_freq);
 
 /*
  * As of now we default to device-tree provided clock
-- 
1.7.7.6
