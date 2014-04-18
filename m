Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaDRIJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:09:40 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:53758 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaDRIJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:09:22 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Peter Zijlstra <peterz@infradead.org>, <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Richard Kuo <rkuo@codeaurora.org>
Subject: [PATCH 2/2] Hexagon: Delete stale barrier.h
Date: Fri, 18 Apr 2014 13:38:35 +0530
Message-ID: <1397808515-8013-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>
References: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is likely Hexagon build is broken too in 3.15.
But I don't have a working compiler to be sure.

Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/hexagon/include/asm/barrier.h | 37 -------------------------------------
 1 file changed, 37 deletions(-)
 delete mode 100644 arch/hexagon/include/asm/barrier.h

diff --git a/arch/hexagon/include/asm/barrier.h b/arch/hexagon/include/asm/barrier.h
deleted file mode 100644
index 4e863daea25b..000000000000
--- a/arch/hexagon/include/asm/barrier.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Memory barrier definitions for the Hexagon architecture
- *
- * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-
-#ifndef _ASM_BARRIER_H
-#define _ASM_BARRIER_H
-
-#define rmb()				barrier()
-#define read_barrier_depends()		barrier()
-#define wmb()				barrier()
-#define mb()				barrier()
-#define smp_rmb()			barrier()
-#define smp_read_barrier_depends()	barrier()
-#define smp_wmb()			barrier()
-#define smp_mb()			barrier()
-
-/*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
-#define set_mb(var, value) \
-	do { var = value; mb(); } while (0)
-
-#endif /* _ASM_BARRIER_H */
-- 
1.8.3.2

