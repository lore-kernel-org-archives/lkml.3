Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3J1Nec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:34:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3J1Nea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:34:30 -0400
Date: Mon, 28 Oct 2013 06:33:36 -0700
From: tip-bot for Michael wang <tipbot@zytor.com>
Message-ID: <tip-ac9ff7997b6f2b31949dcd2495ac671fd9ddc990@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <526DD0EE.1090309@linux.vnet.ibm.com>
References: <526DD0EE.1090309@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove extra put_online_cpus()
  inside sched_setaffinity()
Git-Commit-ID: ac9ff7997b6f2b31949dcd2495ac671fd9ddc990
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 28 Oct 2013 06:33:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac9ff7997b6f2b31949dcd2495ac671fd9ddc990
Gitweb:     http://git.kernel.org/tip/ac9ff7997b6f2b31949dcd2495ac671fd9ddc990
Author:     Michael wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Mon, 28 Oct 2013 10:50:22 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 28 Oct 2013 11:36:50 +0100

sched: Remove extra put_online_cpus() inside sched_setaffinity()

Commit 6acce3ef8:

	sched: Remove get_online_cpus() usage

has left one extra put_online_cpus() inside sched_setaffinity(),
remove it to fix the WARN:

   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus+0x43/0x70()
   ...
   [<ffffffff810c3fef>] put_online_cpus+0x43/0x70 [
   [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9 [
   ...

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/526DD0EE.1090309@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c06b8d3..7c61f31 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	p = find_process_by_pid(pid);
 	if (!p) {
 		rcu_read_unlock();
-		put_online_cpus();
 		return -ESRCH;
 	}
 
