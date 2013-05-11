Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3EKRme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 13:42:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52450 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab3EKRma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 13:42:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [PATCH v6, part3 16/16] AVR32: fix building warnings caused by redifinitions of HZ
Date: Sun, 12 May 2013 01:34:49 +0800
Message-Id: <1368293689-16410-17-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368293689-16410-1-git-send-email-jiang.liu@huawei.com>
References: <1368293689-16410-1-git-send-email-jiang.liu@huawei.com>
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
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/avr32/include/uapi/asm/param.h | 6 +++++-
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
1.8.1.2

