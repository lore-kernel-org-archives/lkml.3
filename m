Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaCXDHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 23:07:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60280 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaCXDHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 23:07:52 -0400
Message-ID: <532FA0E8.4050106@jp.fujitsu.com>
Date: Mon, 24 Mar 2014 12:05:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/2] nohz: fix idle accounting in NO_HZ kernels
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set (based on v3.14-rc7) will fix an issue that
idle/iowait of /proc/stat can go backward. Originally reported
by Tetsuo and Fernando at last year, Mar 2013.

Reviews are welcome.

Thanks,
H.Seto


Hidetoshi Seto (2):
      nohz: use seqlock to avoid race on idle time stats
      nohz, procfs: introduce get_cpu_idle/iowait_time_coarse

 fs/proc/stat.c           |   16 ++---
 include/linux/tick.h     |    5 ++
 kernel/time/tick-sched.c |  171 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 161 insertions(+), 31 deletions(-)

