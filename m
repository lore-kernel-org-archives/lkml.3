Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaHYMiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:38:23 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41484 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaHYMiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:38:21 -0400
Date: Mon, 25 Aug 2014 15:38:25 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: suspicions RCU usage in 3.17.0-rc1-00231-g7be141d on sparc64
Message-ID: <alpine.LRH.2.11.1408251536430.27437@siim2.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is 3.17.0-rc1-00231-g7be141d on sparc64 (4-CPU E420R with US-II 
CPUs). It works fine but gave this during reboot:

[info] Will now restart.
[ 4499.742521]
[ 4499.759281] ===============================
[ 4499.809274] [ INFO: suspicious RCU usage. ]
[ 4499.859270] 3.17.0-rc1-00231-g7be141d #47 Not tainted
[ 4499.919673] -------------------------------
[ 4499.969661] include/linux/rcupdate.h:844 rcu_read_lock() used illegally while idle!
[ 4500.061328]
[ 4500.061328] other info that might help us debug this:
[ 4500.061328]
[ 4500.157159]
[ 4500.157159] RCU used illegally from idle CPU!
[ 4500.157159] rcu_scheduler_active = 1, debug_locks = 0
[ 4500.287348] RCU used illegally from extended quiescent state!
[ 4500.356038] 1 lock held by swapper/0/0:
[ 4500.401850]  #0:  (rcu_read_lock){......}, at: [<00000000004ee944>] __perf_event_exit_context+0x24/0x2c0
[ 4500.515385]
[ 4500.515385] stack backtrace:
[ 4500.567462] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc1-00231-g7be141d #47
[ 4500.659116] Call Trace:
[ 4500.688253]  [000000000049fecc] lockdep_rcu_suspicious+0xcc/0x120
[ 4500.761168]  [00000000004eeba0] __perf_event_exit_context+0x280/0x2c0
[ 4500.838235]  [00000000004d6d24] flush_smp_call_function_queue+0x84/0x1a0
[ 4500.918424]  [00000000004d74a4] generic_smp_call_function_single_interrupt+0x4/0x20
[ 4501.010104]  [000000000043f6d4] smp_call_function_single_client+0x14/0x40
[ 4501.091304]  [0000000000426b74] valid_addr_bitmap_patch+0x8c/0x258
[ 4501.165248]  [000000000042cecc] arch_cpu_idle+0x2c/0xa0
[ 4501.227733]  [000000000049c53c] cpu_startup_entry+0x15c/0x200
[ 4501.296462]  [0000000000829b98] rest_init+0x178/0x1a0
[ 4501.356868]  [00000000009dc9dc] start_kernel+0x3e4/0x3f4
[ 4501.420390]  [0000000000829a0c] tlb_fixup_done+0xa0/0xb4
[ 4501.483910]  [0000000000000000]           (null)
[ 4501.539919] reboot: Restarting system


-- 
Meelis Roos (mroos@linux.ee)
