Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaJHDGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:06:41 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:64381 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaJHDGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:06:40 -0400
Message-ID: <5434AA24.7010600@huawei.com>
Date: Wed, 8 Oct 2014 11:06:12 +0800
From: zhangzhiqiang <zhangzhiqiang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <mark.rutland@arm.com>, <will.deacon@arm.com>, <cov@codeaurora.org>,
        <gregkh@linuxfoundation.org>, <lizefan@huawei.com>,
        <wangnan0@huawei.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] arm: armv7: perf: fix armv7 ref-cycles error
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.157]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.5434AA3C.00F1,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 0d2b5c1098cb5b17585db4180ab94cf4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,
----------------------------------------

ref-cycles event is specially to Intel core, but can still used in arm architecture
with the wrong return value with 3.10 stable. for instance:

 perf stat -e ref-cycles sleep 1

 Performance counter stats for 'sleep 1':

  	0 ref-cycles

       1.002381916 seconds time elapsed

this patch fix the bug and make it return NOT SUPPORTED
distinctly.

In upstream this bug has been fixed by other way(not primary for the bug), which changes more than one file
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

so, can we fix it in this way and put it into 3.10 stable repo.

