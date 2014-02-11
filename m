Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaBKMT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:19:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46640 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaBKMTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:19:54 -0500
Date: Tue, 11 Feb 2014 04:19:01 -0800
From: tip-bot for Jeremy Kerr <tipbot@zytor.com>
Message-ID: <tip-74b8af7837fa55c020e2ad1b34a6b10dfe25a9b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jk@ozlabs.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        fengguang.wu@intel.com, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jk@ozlabs.org, tglx@linutronix.de, sfr@canb.auug.org.au,
        fengguang.wu@intel.com, yangds.fnst@cn.fujitsu.com
In-Reply-To: <1392098717.689604.970589769393.1.gpush@pablo>
References: <1392098717.689604.970589769393.1.gpush@pablo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] powerpc/spufs: Remove MAX_USER_PRIO define
Git-Commit-ID: 74b8af7837fa55c020e2ad1b34a6b10dfe25a9b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:19:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74b8af7837fa55c020e2ad1b34a6b10dfe25a9b1
Gitweb:     http://git.kernel.org/tip/74b8af7837fa55c020e2ad1b34a6b10dfe25a9b1
Author:     Jeremy Kerr <jk@ozlabs.org>
AuthorDate: Tue, 11 Feb 2014 14:05:17 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:33 +0100

powerpc/spufs: Remove MAX_USER_PRIO define

Current ppc64_defconfig fails with:

 arch/powerpc/platforms/cell/spufs/sched.c:86:0: error: "MAX_USER_PRIO" redefined [-Werror]
 cc1: all warnings being treated as errors

Commit 6b6350f155af ("sched: Expose some macros related to priority")
introduced a generic MAX_USER_PRIO macro to sched/prio.h, which is
causing the conflit. Use that one instead of our own.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1392098717.689604.970589769393.1.gpush@pablo
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/sched.c | 1 -
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
 
