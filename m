Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaE3VhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:37:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:46785 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754324AbaE3VhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:37:00 -0400
Date: Fri, 30 May 2014 17:36:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 2/6] rtmutex: Remove builtin tester
Message-ID: <20140530173657.3beb6ea2@gandalf.local.home>
In-Reply-To: <20140522031949.836503239@linutronix.de>
References: <20140522031841.797415507@linutronix.de>
	<20140522031949.836503239@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 03:25:42 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The tester has been broken for quite some time. It's possible to fix
> it, but the main reason for having it in the kernel was the lock steal
> mechanism in the rtmutex code. That's gone, so we can implement a
> stateful correctness tester just via the futex syscall.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/Makefile                               |    1 
>  kernel/locking/rtmutex-tester.c                       |  420 ------------------
>  kernel/locking/rtmutex.c                              |    2 
>  kernel/locking/rtmutex_common.h                       |   22 
>  lib/Kconfig.debug                                     |    6 
>  scripts/rt-tester/check-all.sh                        |   22 
>  scripts/rt-tester/rt-tester.py                        |  220 ---------
>  scripts/rt-tester/t2-l1-2rt-sameprio.tst              |   94 ----
>  scripts/rt-tester/t2-l1-pi.tst                        |   77 ---
>  scripts/rt-tester/t2-l1-signal.tst                    |   72 ---
>  scripts/rt-tester/t2-l2-2rt-deadlock.tst              |   84 ---
>  scripts/rt-tester/t3-l1-pi-1rt.tst                    |   87 ---
>  scripts/rt-tester/t3-l1-pi-2rt.tst                    |   88 ---
>  scripts/rt-tester/t3-l1-pi-3rt.tst                    |   87 ---
>  scripts/rt-tester/t3-l1-pi-signal.tst                 |   93 ---
>  scripts/rt-tester/t3-l1-pi-steal.tst                  |   91 ---
>  scripts/rt-tester/t3-l2-pi.tst                        |   87 ---
>  scripts/rt-tester/t4-l2-pi-deboost.tst                |  118 -----
>  scripts/rt-tester/t5-l4-pi-boost-deboost-setsched.tst |  178 -------
>  scripts/rt-tester/t5-l4-pi-boost-deboost.tst          |  138 -----
>  20 files changed, 1 insertion(+), 1986 deletions(-)
> 

Missed some:

-- Steve

diff --git a/arch/parisc/configs/c8000_defconfig b/arch/parisc/configs/c8000_defconfig
index 8249ac9..4e407e0 100644
--- a/arch/parisc/configs/c8000_defconfig
+++ b/arch/parisc/configs/c8000_defconfig
@@ -241,7 +241,6 @@ CONFIG_LOCKUP_DETECTOR=y
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
 CONFIG_PANIC_ON_OOPS=y
 CONFIG_DEBUG_RT_MUTEXES=y
-CONFIG_RT_MUTEX_TESTER=y
 CONFIG_PROVE_RCU_DELAY=y
 CONFIG_DEBUG_BLOCK_EXT_DEVT=y
 CONFIG_LATENCYTOP=y
diff --git a/arch/parisc/configs/generic-32bit_defconfig b/arch/parisc/configs/generic-32bit_defconfig
index 33b148f..0ffb08f 100644
--- a/arch/parisc/configs/generic-32bit_defconfig
+++ b/arch/parisc/configs/generic-32bit_defconfig
@@ -295,7 +295,6 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_RT_MUTEXES=y
-CONFIG_RT_MUTEX_TESTER=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_RCU_CPU_STALL_INFO=y
diff --git a/arch/s390/configs/default_defconfig b/arch/s390/configs/default_defconfig
index 8df022c..2b3ef70 100644
--- a/arch/s390/configs/default_defconfig
+++ b/arch/s390/configs/default_defconfig
@@ -574,7 +574,6 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_RT_MUTEXES=y
-CONFIG_RT_MUTEX_TESTER=y
 CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_LOCK_STAT=y
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 1493c68..5e922fe 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -619,7 +619,6 @@ CONFIG_SCHED_DEBUG=y
 # CONFIG_SLUB_DEBUG_ON is not set
 # CONFIG_SLUB_STATS is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
-# CONFIG_RT_MUTEX_TESTER is not set
 # CONFIG_DEBUG_SPINLOCK is not set
 # CONFIG_DEBUG_MUTEXES is not set
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 12a492a..4b900c9 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -560,7 +560,6 @@ CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
 # CONFIG_DEBUG_OBJECTS is not set
 # CONFIG_DEBUG_SLAB is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
-# CONFIG_RT_MUTEX_TESTER is not set
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y

