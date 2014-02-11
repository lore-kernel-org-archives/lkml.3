Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaBKJmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:42:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48724 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaBKJmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:42:03 -0500
Date: Tue, 11 Feb 2014 10:41:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Ingo Molnar <mingo@kernel.org>, kbuild-all@01.org,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/spufs: Fix duplicate definition of MAX_USER_PRIO
Message-ID: <20140211094106.GM27965@twins.programming.kicks-ass.net>
References: <52f92761.nu9w3QblrTnGpeYg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52f92761.nu9w3QblrTnGpeYg%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:24:17AM +0800, kbuild test robot wrote:
> >> arch/powerpc/platforms/cell/spufs/sched.c:86:0: warning: "MAX_USER_PRIO" redefined [enabled by default]
>     #define MAX_USER_PRIO  (MAX_PRIO - MAX_RT_PRIO)
>     ^
>    In file included from include/linux/sched.h:6:0,
>                     from arch/powerpc/platforms/cell/spufs/sched.c:26:
>    include/linux/sched/prio.h:39:0: note: this is the location of the previous definition
>     #define MAX_USER_PRIO  (USER_PRIO(MAX_PRIO))
>     ^

Since USER_PRIO(p) is ((p)-MAX_RT_PRIO) the above two definitions are
the same and we can simply remove the spufs one.

Fixes: 6b6350f155af ("sched: Expose some macros related to priority")
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/powerpc/platforms/cell/spufs/sched.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 49318385d4fa..4a0a64fe25df 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -83,7 +83,6 @@ static struct timer_list spuloadavg_timer;
 #define MIN_SPU_TIMESLICE	max(5 * HZ / (1000 * SPUSCHED_TICK), 1)
 #define DEF_SPU_TIMESLICE	(100 * HZ / (1000 * SPUSCHED_TICK))
 
-#define MAX_USER_PRIO		(MAX_PRIO - MAX_RT_PRIO)
 #define SCALE_PRIO(x, prio) \
 	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_SPU_TIMESLICE)
 
