Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3CEIGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:06:04 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:36114 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3CEIGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:06:02 -0500
Message-ID: <5135A736.8050104@huawei.com>
Date: Tue, 5 Mar 2013 16:05:10 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] sched: Shrink include/linux/sched.h
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working of a cgroup patch which also touched include/linux/sched.h,
I found some function/macro/structure declarations can be moved to
kernel/sched/sched.h, and some can even be total removed, so here's
the patchset.

The result is a reduction of ~200 LOC from include/linux/sched.h.

0001-sched-Remove-some-dummpy-functions.patch
0002-sched-Remove-test_sd_parent.patch
0003-sched-Move-SCHED_LOAD_SHIFT-macros-to-kernel-sched-s.patch
0004-sched-Move-struct-sched_group-to-kernel-sched-sched..patch
0005-sched-Move-wake-flags-to-kernel-sched-sched.h.patch
0006-sched-Move-struct-sched_class-to-kernel-sched-sched..patch
0007-sched-Make-default_scale_freq_power-static.patch
0008-sched-Move-group-scheduling-functions-out-of-include.patch
0009-sched-Remove-double-declaration-of-root_task_group.patch

--
 include/linux/sched.h | 194 +-------------------------------------------------
 kernel/sched/core.c   |  14 ++--
 kernel/sched/fair.c   |   6 +-
 kernel/sched/sched.h  | 159 +++++++++++++++++++++++++++++++++++++++--
 4 files changed, 168 insertions(+), 205 deletions(-)

