Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaIZHok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:44:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24002 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaIZHoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:44:38 -0400
Message-ID: <54251956.6010407@huawei.com>
Date: Fri, 26 Sep 2014 15:44:22 +0800
From: zhangzhiqiang <zhangzhiqiang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <lizefan@huawei.com>, <wangnan0@huawei.com>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH] arm: armv7: perf: fix armv7 ref-cycles error
References: <1411123266-60784-1-git-send-email-zhangzhiqiang.zhang@huawei.com>
In-Reply-To: <1411123266-60784-1-git-send-email-zhangzhiqiang.zhang@huawei.com>
X-Forwarded-Message-Id: <1411123266-60784-1-git-send-email-zhangzhiqiang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.157]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,
----------------------------------------

ref-cycles event is specially to Intel core, but can still used in arm architecture
with the wrong return value with 3.10 stable. this patch fix the bug and make it return NOT SUPPORTED
distinctly.

In upstream this bug has been fixed by other way, which changes more than one file
and more than 1000 lines. the primary commit is 6b7658ec8a100b608e59e3cde353434db51f5be0.
besides we can not simply cherry-pick.

Signed-off-by: Zhiqiang Zhang <zhangzhiqiang.zhang@huawei.com>
---
 arch/arm/kernel/perf_event_v7.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 039cffb..c3d24aa 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -126,6 +126,7 @@ static const unsigned armv7_a8_perf_map[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_BUS_CYCLES]		= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= ARMV7_A8_PERFCTR_STALL_ISIDE,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES]	= HW_OP_UNSUPPORTED,
 };

 static const unsigned armv7_a8_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -250,6 +251,7 @@ static const unsigned armv7_a9_perf_map[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_BUS_CYCLES]		= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= ARMV7_A9_PERFCTR_STALL_ICACHE,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= ARMV7_A9_PERFCTR_STALL_DISPATCH,
+	[PERF_COUNT_HW_REF_CPU_CYCLES]	= HW_OP_UNSUPPORTED,
 };

 static const unsigned armv7_a9_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -374,6 +376,7 @@ static const unsigned armv7_a5_perf_map[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_BUS_CYCLES]		= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = HW_OP_UNSUPPORTED,
 };

 static const unsigned armv7_a5_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -496,6 +499,7 @@ static const unsigned armv7_a15_perf_map[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_BUS_CYCLES]		= ARMV7_PERFCTR_BUS_CYCLES,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = HW_OP_UNSUPPORTED,
 };

 static const unsigned armv7_a15_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -620,6 +624,7 @@ static const unsigned armv7_a7_perf_map[PERF_COUNT_HW_MAX] = {
 	[PERF_COUNT_HW_BUS_CYCLES]		= ARMV7_PERFCTR_BUS_CYCLES,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = HW_OP_UNSUPPORTED,
 };

 static const unsigned armv7_a7_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
--

can we put it into stable repo.


.




