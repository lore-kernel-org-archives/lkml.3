Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaLXFiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:38:46 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:42762 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbaLXFio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:38:44 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Daniel Mack <daniel@zonque.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michal Nazarewicz <mina86@mina86.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Joe Perches <joe@perches.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Elder <alex.elder@linaro.org>, Daniel Walter <dwalter@google.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH] linux/kernel.h: merge ARRAY_AND_SIZE defines
Date: Wed, 24 Dec 2014 14:38:16 +0900
Message-Id: <1419399496-5955-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARRAY_AND_SIZE is a useful macro.  Its definition is already
duplicated in some headers.  Move it to include/linux/kernel.h.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 arch/arm/mach-mmp/common.h        | 1 -
 arch/arm/mach-pxa/generic.h       | 2 --
 arch/arm/mach-ux500/db8500-regs.h | 2 --
 drivers/pinctrl/pinctrl-lantiq.h  | 2 --
 include/linux/kernel.h            | 1 +
 5 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm/mach-mmp/common.h b/arch/arm/mach-mmp/common.h
index cf445ba..e503f63 100644
--- a/arch/arm/mach-mmp/common.h
+++ b/arch/arm/mach-mmp/common.h
@@ -1,5 +1,4 @@
 #include <linux/reboot.h>
-#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
 
 extern void timer_init(int irq);
 
diff --git a/arch/arm/mach-pxa/generic.h b/arch/arm/mach-pxa/generic.h
index 7a9fa1a..da11977 100644
--- a/arch/arm/mach-pxa/generic.h
+++ b/arch/arm/mach-pxa/generic.h
@@ -23,8 +23,6 @@ extern void pxa_timer_init(void);
 	mi->bank[__nr].start = (__start), \
 	mi->bank[__nr].size = (__size)
 
-#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
-
 #define pxa25x_handle_irq icip_handle_irq
 extern void __init pxa25x_init_irq(void);
 extern void __init pxa25x_map_io(void);
diff --git a/arch/arm/mach-ux500/db8500-regs.h b/arch/arm/mach-ux500/db8500-regs.h
index 2739955..80a6deb 100644
--- a/arch/arm/mach-ux500/db8500-regs.h
+++ b/arch/arm/mach-ux500/db8500-regs.h
@@ -195,6 +195,4 @@
 /* Used by some plat-nomadik code */
 #define io_p2v(n)		__io_address(n)
 
-#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
-
 #endif
diff --git a/drivers/pinctrl/pinctrl-lantiq.h b/drivers/pinctrl/pinctrl-lantiq.h
index c7cfad5..508d205 100644
--- a/drivers/pinctrl/pinctrl-lantiq.h
+++ b/drivers/pinctrl/pinctrl-lantiq.h
@@ -21,8 +21,6 @@
 
 #include "core.h"
 
-#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
-
 #define LTQ_MAX_MUX		4
 #define MFPR_FUNC_MASK		0x3
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 049d43b..4e8fc3d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -59,6 +59,7 @@ void printch(int c);
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
 
 /*
  * This looks more complex than it should be. But we need to
-- 
1.9.1

