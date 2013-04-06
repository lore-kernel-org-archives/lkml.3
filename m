Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423342Ab3DFQnv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:43:51 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53086 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423316Ab3DFQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:43:50 -0400
From: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] AVR32: fix building warnings caused by redifinitions of HZ
Date: Sun,  7 Apr 2013 00:43:36 +0800
Message-Id: <1365266616-8424-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building warnings caused by redifinitions of HZ:
In file included from /ws/linux/kernel/linux.git/include/uapi/linux/param.h:4,
                 from include/linux/timex.h:63,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
                 from include/linux/srcu.h:34,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:777,
                 from include/linux/gfp.h:4,
                 from arch/avr32/mm/init.c:10:
/ws/linux/kernel/linux.git/arch/avr32/include/asm/param.h:6:1: warning: "HZ" redefined
In file included from /ws/linux/kernel/linux.git/arch/avr32/include/asm/param.h:4,
                 from /ws/linux/kernel/linux.git/include/uapi/linux/param.h:4,
                 from include/linux/timex.h:63,
                 from include/linux/jiffies.h:8,
                 from include/linux/ktime.h:25,
                 from include/linux/timer.h:5,
                 from include/linux/workqueue.h:8,
                 from include/linux/srcu.h:34,
                 from include/linux/notifier.h:15,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:777,
                 from include/linux/gfp.h:4,
                 from arch/avr32/mm/init.c:10:
/ws/linux/kernel/linux.git/arch/avr32/include/uapi/asm/param.h:6:1: warning: this is the location of the previous definition

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org
---
 arch/avr32/include/uapi/asm/param.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/avr32/include/uapi/asm/param.h b/arch/avr32/include/uapi/asm/param.h
index d28aa5e..abda103 100644
--- a/arch/avr32/include/uapi/asm/param.h
+++ b/arch/avr32/include/uapi/asm/param.h
@@ -2,7 +2,11 @@
 #define _UAPI__ASM_AVR32_PARAM_H
 
 
-#ifndef HZ
+#ifndef __KERNEL__
+   /*
+    * Technically, this is wrong, but some old apps still refer to it.
+    * The proper way to get the HZ value is via sysconf(_SC_CLK_TCK).
+    */
 # define HZ		100
 #endif
 
-- 
1.7.9.5

