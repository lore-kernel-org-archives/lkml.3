Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916Ab3DHKAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:00:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964866Ab3DHKAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:00:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,431,1363104000"; 
   d="scan'208";a="7014991"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org
Cc: cl@linux.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, catalin.marinas@arm.com, will.deacon@arm.com,
        arnd@arndb.de, tony@atomide.com, ben@decadent.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, isimatu.yasuaki@jp.fujitsu.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH 2/2] mm: vmemmap: arm64: add vmemmap_verify check for hot-add node case
Date: Mon, 8 Apr 2013 17:56:40 +0800
Message-Id: <1365415000-10389-3-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 17:53:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 17:54:29,
	Serialize complete at 2013/04/08 17:54:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hot add node(memory) case, vmemmap pages are always allocated from other
node, but the current logic just skip vmemmap_verify check. 
So we should also issue "potential offnode page_structs" warning messages
if we are the case.

Cc: Christoph Lameter <cl@linux.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 arch/arm64/mm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 70b8cd4..9f1e417 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -427,8 +427,8 @@ int __meminit vmemmap_populate(struct page *start_page,
 				return -ENOMEM;
 
 			set_pmd(pmd, __pmd(__pa(p) | prot_sect_kernel));
-		} else
-			vmemmap_verify((pte_t *)pmd, node, addr, next);
+		}
+		vmemmap_verify((pte_t *)pmd, node, addr, next);
 	} while (addr = next, addr != end);
 
 	return 0;
-- 
1.8.0.1

