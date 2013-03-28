Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3C1HVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:21:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24818 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab3C1HVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:21:12 -0400
Message-ID: <5153EF24.3040608@huawei.com>
Date: Thu, 28 Mar 2013 15:20:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 0/5] cpuacct, cgroup: Remove cgroup_subsys.active
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuacct is the only user of cgroup_subsys.active flag.

The flag is needed because cpuacct_charge() and cpuacct_account_field() can
be called when cpuacct hasn't been initialized during system bootup.

This patch initializes cpuacct earlier, and the result is we don't have
to check the flag in scheduler hot path.

Note, this patchset is based on "[PATCH 0/7] sched: Split cpuacct"
(just because there're code conflicts)

	http://lkml.org/lkml/2013/3/28/1

0001-cpuacct-allocate-per_cpu-cpuusage-for-root-cpuacct-s.patch
0002-cpuacct-Initialize-root-cpuacct-earlier.patch
0003-cpuacct-Initialize-cpuacct-subsystem-earlier.patch
0004-cpuacct-No-need-to-check-subsys-active-state.patch
0005-cgroup-Remove-subsys.active-flag.patch

--
 include/linux/cgroup.h |  1 -
 kernel/cgroup.c        |  3 ---
 kernel/sched/core.c    |  2 --
 kernel/sched/cpuacct.c | 30 +++++++++++-------------------
 kernel/sched/cpuacct.h |  5 -----
 5 files changed, 11 insertions(+), 30 deletions(-)
