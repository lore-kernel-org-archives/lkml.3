Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3C3K3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 06:29:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11612 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3C3K3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 06:29:30 -0400
Message-ID: <5156BE4A.2030400@huawei.com>
Date: Sat, 30 Mar 2013 18:28:26 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: <sam@ravnborg.org>, <davem@davemloft.net>
CC: <sparclinux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
        <wangyijing@huawei.com>
Subject: [PATCH] sparc:cleanup unused code in smp_32.h
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After genirq and generic clockevent support at sparc32,
smp4m_irq_rotate(), prof_multiplier() and prof_counter()
are no longer used and should be removed.

Find more info from commit 6baa9b20 & 62f08283.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 arch/sparc/include/asm/smp_32.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/include/asm/smp_32.h b/arch/sparc/include/asm/smp_32.h
index 68503d3..3c8917f 100644
--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -36,7 +36,6 @@ typedef void (*smpfunc_t)(unsigned long, unsigned long, unsigned long,
 		       unsigned long, unsigned long);

 void cpu_panic(void);
-extern void smp4m_irq_rotate(int cpu);

 /*
  *	General functions that each host system must provide.
@@ -106,9 +105,6 @@ extern int hard_smp_processor_id(void);

 #define raw_smp_processor_id()		(current_thread_info()->cpu)

-#define prof_multiplier(__cpu)		cpu_data(__cpu).multiplier
-#define prof_counter(__cpu)		cpu_data(__cpu).counter
-
 void smp_setup_cpu_possible_map(void);

 #endif /* !(__ASSEMBLY__) */
-- 
1.6.0.2

