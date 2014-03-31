Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaCaCCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:02:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33709 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaCaCCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:02:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5338CC86.9080602@jp.fujitsu.com>
Date: Mon, 31 Mar 2014 11:01:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH 0/2 v2] nohz: fix idle accounting in NO_HZ kernels
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set (rebased on v3.14-rc8) will fix an issue that
idle/iowait of /proc/stat can go backward. Originally reported
by Tetsuo and Fernando at last year, Mar 2013.

v2 have Preeti's Reviewed-by (Thanks!).
Of course still reviews are welcome.

Thanks,
H.Seto


Hidetoshi Seto (2):
      nohz: use seqlock to avoid race on idle time stats v2
      nohz, procfs: introduce get_cpu_idle/iowait_time_coarse

 fs/proc/stat.c           |   16 ++---
 include/linux/tick.h     |    5 +
 kernel/time/tick-sched.c |  197 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 183 insertions(+), 35 deletions(-)

