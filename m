Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3J1GT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:19:29 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59261 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab3J1GT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:19:28 -0400
X-Spam-Score: -100.8
Message-ID: <526E01B4.6040205@asianux.com>
Date: Mon, 28 Oct 2013 14:18:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, noamc@ezchip.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] arc: kernel: use exporting symbol instead of static inline
 for arc_get_core_freq()
References: <526DDAE5.9040803@asianux.com> <526E010F.90602@asianux.com>
In-Reply-To: <526E010F.90602@asianux.com>
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
index 10c7b0b..798be4a 100644
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
+EXPORT_SYMBOL(arc_get_core_freq);
 
 /*
  * As of now we default to device-tree provided clock
-- 
1.7.7.6
