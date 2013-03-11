Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3CKJ6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:58:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38191 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3CKJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:58:30 -0400
Date: Mon, 11 Mar 2013 02:57:05 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-cb16b91a449afd01b85ec4e59f30449d11c4acd7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        fengguang.wu@intel.com, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        fengguang.wu@intel.com, lizefan@huawei.com
In-Reply-To: <51385F79.7000106@huawei.com>
References: <51385F79.7000106@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] s390:
  Fix a header dependencies related build error
Git-Commit-ID: cb16b91a449afd01b85ec4e59f30449d11c4acd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Mar 2013 02:57:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb16b91a449afd01b85ec4e59f30449d11c4acd7
Gitweb:     http://git.kernel.org/tip/cb16b91a449afd01b85ec4e59f30449d11c4acd7
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Thu, 7 Mar 2013 17:35:53 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Mar 2013 10:43:35 +0100

s390: Fix a header dependencies related build error

Commit 877c685607925238e302cd3aa38788dca6c1b226
("perf: Remove include of cgroup.h from perf_event.h") caused
this build failure if PERF_EVENTS is enabled:

   In file included from arch/s390/include/asm/perf_event.h:9:0,
                    from include/linux/perf_event.h:24,
                    from kernel/events/ring_buffer.c:12:
   arch/s390/include/asm/cpu_mf.h: In function 'qctri':
   arch/s390/include/asm/cpu_mf.h:61:12: error: 'EINVAL' undeclared (first use in this function)

cpu_mf.h had an implicit errno.h dependency, which was added
indirectly via cgroups.h but not anymore. Add it explicitly.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Link: http://lkml.kernel.org/r/51385F79.7000106@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/s390/include/asm/cpu_mf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/include/asm/cpu_mf.h b/arch/s390/include/asm/cpu_mf.h
index 35f0020..c7c9bf6 100644
--- a/arch/s390/include/asm/cpu_mf.h
+++ b/arch/s390/include/asm/cpu_mf.h
@@ -12,6 +12,7 @@
 #ifndef _ASM_S390_CPU_MF_H
 #define _ASM_S390_CPU_MF_H
 
+#include <linux/errno.h>
 #include <asm/facility.h>
 
 #define CPU_MF_INT_SF_IAE	(1 << 31)	/* invalid entry address */
