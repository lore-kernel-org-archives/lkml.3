Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaJCUTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:19:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaJCUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:19:42 -0400
Subject: Patch "arm: armv7: perf: fix armv7 ref-cycles error" has been added to the 3.16-stable tree
To: zhangzhiqiang.zhang@huawei.com, cov@codeaurora.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, mark.rutland@arm.com, stable@vger.kernel.org,
        wangnan0@huawei.com, will.deacon@arm.com
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 03 Oct 2014 13:19:40 -0700
In-Reply-To: <54251956.6010407@huawei.com>
Message-ID: <14123675803376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    arm: armv7: perf: fix armv7 ref-cycles error

to the 3.16-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     arm-armv7-perf-fix-armv7-ref-cycles-error.patch
and it can be found in the queue-3.16 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From zhangzhiqiang.zhang@huawei.com  Fri Oct  3 13:04:46 2014
From: zhangzhiqiang <zhangzhiqiang.zhang@huawei.com>
Date: Fri, 26 Sep 2014 15:44:22 +0800
Subject: arm: armv7: perf: fix armv7 ref-cycles error
To: <gregkh@linuxfoundation.org>, <lizefan@huawei.com>, <wangnan0@huawei.com>, <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <54251956.6010407@huawei.com>


From: Zhiqiang Zhang <zhangzhiqiang.zhang@huawei.com>

ref-cycles event is specially to Intel core, but can still used in arm
architecture with the wrong return value with 3.10 stable. this patch fix the
bug and make it return NOT SUPPORTED distinctly.

In upstream this bug has been fixed by other way, which changes more than one
file and more than 1000 lines. the primary commit is
6b7658ec8a100b608e59e3cde353434db51f5be0.  besides we can not simply
cherry-pick.

Signed-off-by: Zhiqiang Zhang <zhangzhiqiang.zhang@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event_v7.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -157,6 +157,7 @@ static const unsigned armv7_a8_perf_map[
 	[PERF_COUNT_HW_BUS_CYCLES]		= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= ARMV7_A8_PERFCTR_STALL_ISIDE,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES]	= HW_OP_UNSUPPORTED,
 };
 
 static const unsigned armv7_a8_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -281,6 +282,7 @@ static const unsigned armv7_a9_perf_map[
 	[PERF_COUNT_HW_BUS_CYCLES]		= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= ARMV7_A9_PERFCTR_STALL_ICACHE,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= ARMV7_A9_PERFCTR_STALL_DISPATCH,
+	[PERF_COUNT_HW_REF_CPU_CYCLES]	= HW_OP_UNSUPPORTED,
 };
 
 static const unsigned armv7_a9_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -405,6 +407,7 @@ static const unsigned armv7_a5_perf_map[
 	[PERF_COUNT_HW_BUS_CYCLES]		= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = HW_OP_UNSUPPORTED,
 };
 
 static const unsigned armv7_a5_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -527,6 +530,7 @@ static const unsigned armv7_a15_perf_map
 	[PERF_COUNT_HW_BUS_CYCLES]		= ARMV7_PERFCTR_BUS_CYCLES,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = HW_OP_UNSUPPORTED,
 };
 
 static const unsigned armv7_a15_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
@@ -651,6 +655,7 @@ static const unsigned armv7_a7_perf_map[
 	[PERF_COUNT_HW_BUS_CYCLES]		= ARMV7_PERFCTR_BUS_CYCLES,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= HW_OP_UNSUPPORTED,
 	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]	= HW_OP_UNSUPPORTED,
+	[PERF_COUNT_HW_REF_CPU_CYCLES] = HW_OP_UNSUPPORTED,
 };
 
 static const unsigned armv7_a7_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]


Patches currently in stable-queue which might be from zhangzhiqiang.zhang@huawei.com are

queue-3.16/arm-armv7-perf-fix-armv7-ref-cycles-error.patch
