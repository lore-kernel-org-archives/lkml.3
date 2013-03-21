Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab3CUQcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:32:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34009 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab3CUQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:31:59 -0400
From: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] h8300: add missing definition for read_barries_depends()
Date: Fri, 22 Mar 2013 00:31:44 +0800
Message-Id: <1363883504-6140-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363883504-6140-1-git-send-email-jiang.liu@huawei.com>
References: <1363883504-6140-1-git-send-email-jiang.liu@huawei.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing definition for read_barries_depends() for h8300 to fix error:
kernel/task_work.c: In function 'task_work_cancel':
kernel/task_work.c:38:3: error: implicit declaration of function 'read_barrier_depends' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [kernel/task_work.o] Error 1
make: *** [kernel] Error 2

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/h8300/include/asm/barrier.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/h8300/include/asm/barrier.h b/arch/h8300/include/asm/barrier.h
index c7283c3..9e0aa9f 100644
--- a/arch/h8300/include/asm/barrier.h
+++ b/arch/h8300/include/asm/barrier.h
@@ -12,6 +12,8 @@
 #define wmb()  asm volatile (""   : : :"memory")
 #define set_mb(var, value) do { xchg(&var, value); } while (0)
 
+#define read_barrier_depends()	do { } while (0)
+
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
-- 
1.7.9.5

