Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbaBKGFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:05:30 -0500
Received: from ozlabs.org ([203.10.76.45]:58707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaBKGF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:05:28 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] powerpc/spufs: Remove MAX_USER_PRIO define
Message-Id: <1392098717.689604.970589769393.1.gpush@pablo>
To: Ingo Molnar <mingo@kernel.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Jeremy Kerr <jk@ozlabs.org>
Date: Tue, 11 Feb 2014 14:05:17 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current ppc64_defconfig fails with:

 arch/powerpc/platforms/cell/spufs/sched.c:86:0: error: "MAX_USER_PRIO" redefined [-Werror]
 cc1: all warnings being treated as errors

6b6350f1 introduced a generic MAX_USER_PRIO macro to sched/prio.h, which
is causing the conflit. Use that one instead of our own.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
Ingo: 6b6350f1 is currently in tip; this fixes a build breakage for spufs

---
 arch/powerpc/platforms/cell/spufs/sched.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 4931838..4a0a64f 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -83,7 +83,6 @@ static struct timer_list spuloadavg_timer;
 #define MIN_SPU_TIMESLICE	max(5 * HZ / (1000 * SPUSCHED_TICK), 1)
 #define DEF_SPU_TIMESLICE	(100 * HZ / (1000 * SPUSCHED_TICK))
 
-#define MAX_USER_PRIO		(MAX_PRIO - MAX_RT_PRIO)
 #define SCALE_PRIO(x, prio) \
 	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_SPU_TIMESLICE)
 
