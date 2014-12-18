Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaLRLCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:02:34 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:59086 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaLRLCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:02:33 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] MIPS: Remove unneeded #ifdef __KERNEL__ from asm/processor.h
Date: Thu, 18 Dec 2014 13:59:53 +0300
Message-ID: <1418900405-18900-1-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/include/asm/processor.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index f1df4cb..6c10e94 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -54,9 +54,7 @@ extern unsigned int vced_count, vcei_count;
 #define TASK_SIZE	0x7fff8000UL
 #endif
 
-#ifdef __KERNEL__
 #define STACK_TOP_MAX	TASK_SIZE
-#endif
 
 #define TASK_IS_32BIT_ADDR 1
 
@@ -73,11 +71,7 @@ extern unsigned int vced_count, vcei_count;
 #define TASK_SIZE32	0x7fff8000UL
 #define TASK_SIZE64	0x10000000000UL
 #define TASK_SIZE (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE64)
-
-#ifdef __KERNEL__
 #define STACK_TOP_MAX	TASK_SIZE64
-#endif
-
 
 #define TASK_SIZE_OF(tsk)						\
 	(test_tsk_thread_flag(tsk, TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE64)
-- 
2.1.3

