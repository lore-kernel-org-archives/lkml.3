Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860Ab3EHEAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 00:00:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24813 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab3EHEAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 00:00:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,632,1363104000"; 
   d="scan'208";a="7212742"
Message-ID: <5189C88B.4030409@cn.fujitsu.com>
Date: Wed, 08 May 2013 11:37:47 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: mm: Remove the alwalys zero if test
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/08 11:38:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/08 11:39:41,
	Serialize complete at 2013/05/08 11:39:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This if test seems useless now, so remove it. 

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/mm/init_64.c |    3 --- 
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bb00c46..d1238fe 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -431,9 +431,6 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
                        continue;
                }   
 
-               if (0)
-                       printk("   pte=%p addr=%lx pte=%016lx\n",
-                              pte, addr, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL).pte);
                pages++;
                set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, prot));
                last_map_addr = (addr & PAGE_MASK) + PAGE_SIZE;
-- 
1.7.1

