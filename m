Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3EJJDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:03:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3EJJDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:03:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,647,1363104000"; 
   d="scan'208";a="7233881"
Message-ID: <518CB758.4000101@cn.fujitsu.com>
Date: Fri, 10 May 2013 17:01:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: yinghai@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: mm: Remove unnecessary assignment for max_pfn_mapped:q
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/10 17:02:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/10 17:02:30,
	Serialize complete at 2013/05/10 17:02:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_memory_mapping will set max_pfn_mapped:
int_memory_mapping
  --> add_pfn_range_mapped
    --> max_pfn_mapped = max(max_pfn_mapped, end_pfn)

In init_mem_mapping, before we set max_pfn_mapped to 0, we
have already called init_memory_mapping to setup pagetable
for [0, ISA_END_ADDRESS], and that sets max_pfn_mapped. So
the assignment to 0 is not necessary, remove it.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fdc5dca..404c889 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -416,7 +416,6 @@ void __init init_mem_mapping(void)
 
 	/* step_size need to be small so pgt_buf from BRK could cover it */
 	step_size = PMD_SIZE;
-	max_pfn_mapped = 0; /* will get exact value next */
 	min_pfn_mapped = real_end >> PAGE_SHIFT;
 	last_start = start = real_end;
 	while (last_start > ISA_END_ADDRESS) {
-- 
1.7.1

