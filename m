Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3KVGhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:37:42 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55032 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3KVGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:37:38 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] sched: remove cpu_load decay.
Date: Fri, 22 Nov 2013 14:37:11 +0800
Message-Id: <1385102235-25664-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_load decays on time according past cpu load of rq. New sched_avg decays on tasks' load of time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load in sched_tick etc.

This patch trying to remove the cpu_load decay. And fixed a nohz_full bug by the way. 

There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change. :)

I have tested the patchset on my pandaES board, 2 cores ARM Cortex A9.
hackbench thread/pipe performance increased nearly 10% with this patchset! That do surprise me!

	latest kernel 527d1511310a89		+ this patchset
hackbench -T -g 10 -f 40
	23.25"					21.7"
	23.16"					19.99"
	24.24"					21.53"
hackbench -p -g 10 -f 40
	26.52"					22.48"
	23.89"					24.00"
	25.65"					23.06"
hackbench -P -g 10 -f 40
	20.14"					19.37"
	19.96"					19.76"
	21.76"					21.54"

The git tree for this patchset at:
 git@github.com:alexshi/power-scheduling.git no-load-idx 
Since Fengguang had included this tree into his kernel testing system. and I haven't get a regression report until now. I suppose it is fine for x86 system.

But anyway, since the scheduler change will effect all archs. and hackbench is only benchmark I found now for this patchset. I'd like to see more testing and talking on this patchset.

Regards
Alex

