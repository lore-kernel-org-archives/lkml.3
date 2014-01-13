Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaAMI6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:58:30 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9315 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbaAMI61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:58:27 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <marc.zyngier@arm.com>, Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] arm64: fix typo in entry.S
Date: Mon, 13 Jan 2014 16:57:56 +0800
Message-ID: <1389603476-10494-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-12_03:2014-01-10,2014-01-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401130010
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 64681787 (arm64: let the core code deal with preempt_count)
changed the code, but left the comments unchanged, fix it.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm64/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 4d2c6f3..ffce55e 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -314,7 +314,7 @@ el1_irq:
 
 #ifdef CONFIG_PREEMPT
 	get_thread_info tsk
-	ldr	w24, [tsk, #TI_PREEMPT]		// restore preempt count
+	ldr	w24, [tsk, #TI_PREEMPT]		// get preempt count
 	cbnz	w24, 1f				// preempt count != 0
 	ldr	x0, [tsk, #TI_FLAGS]		// get flags
 	tbz	x0, #TIF_NEED_RESCHED, 1f	// needs rescheduling?
-- 
1.7.9.5

