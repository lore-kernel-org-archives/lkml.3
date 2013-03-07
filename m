Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab3CGJge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:36:34 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:5083 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3CGJgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:36:25 -0500
Message-ID: <51385F79.7000106@huawei.com>
Date: Thu, 7 Mar 2013 17:35:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][RESEND] s390: Fix a build error
References: <5137EB66.9050509@huawei.com>
In-Reply-To: <5137EB66.9050509@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 877c685607925238e302cd3aa38788dca6c1b226
("perf: Remove include of cgroup.h from perf_event.h") caused this:

   In file included from arch/s390/include/asm/perf_event.h:9:0,
                    from include/linux/perf_event.h:24,
                    from kernel/events/ring_buffer.c:12:
   arch/s390/include/asm/cpu_mf.h: In function 'qctri':
   arch/s390/include/asm/cpu_mf.h:61:12: error: 'EINVAL' undeclared
   (first use in this function)

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---

CC LKML, and add tested-by tag.

---
 arch/s390/include/asm/cpu_mf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/include/asm/cpu_mf.h b/arch/s390/include/asm/cpu_mf.h
index f1eddd1..c879fad 100644
--- a/arch/s390/include/asm/cpu_mf.h
+++ b/arch/s390/include/asm/cpu_mf.h
@@ -12,6 +12,7 @@
 #ifndef _ASM_S390_CPU_MF_H
 #define _ASM_S390_CPU_MF_H
 
+#include <linux/errno.h>
 #include <asm/facility.h>
 
 #define CPU_MF_INT_SF_IAE	(1 << 31)	/* invalid entry address */
-- 
1.8.0.2
