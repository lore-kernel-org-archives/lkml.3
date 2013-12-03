Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3LCJGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:06:49 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61922 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3LCJGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:06:41 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] sched: remove cpu_load decay
Date: Tue,  3 Dec 2013 17:05:52 +0800
Message-Id: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_load decays on time according past cpu load of rq. New sched_avg decays on tasks' load of time. Now we has 2 kind decay for cpu_load. That is a kind of redundancy. And increase the system load in sched_tick etc.

This patch removes the cpu_load decay. 

There are 5 load_idx used for cpu_load in sched_domain. busy_idx and idle_idx are not zero usually, but newidle_idx, wake_idx and forkexec_idx are all zero on every arch. A shortcut to remove cpu_Load decay in the first patch. just one line patch for this change. :)

I have tested the patchset on my pandaES board, 2 cores ARM Cortex A9.
hackbench thread/pipe performance increased nearly 8% with this patchset!

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

Daniel tested this patchset on his Core2 2 socket server, the hackbench has no clear regression/improvement.
This patchset is also in Fengguang's x86 testing for more than 1 week, and no regression report until now. 
Fengguang, could I assume there is no regression on Intel platforms? :)

The git tree for this patchset at:
 git@github.com:alexshi/power-scheduling.git no-load-idx 

--
Thanks
	Alex
