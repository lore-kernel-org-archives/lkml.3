Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3CRLMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:12:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab3CRLLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:11:44 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355068800"; 
   d="scan'208";a="6893859"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH] x86: mm: accurate the comments for STEP_SIZE_SHIFT macro
Date: Mon, 18 Mar 2013 18:21:08 +0800
Message-Id: <1363602068-11924-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 18:17:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/18 18:17:40,
	Serialize complete at 2013/03/18 18:17:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 PUD_SHIFT is 30 and PMD_SHIFT is 21, so the consequence of
(PUD_SHIFT-PMD_SHIFT)/2 is 4. Update the comments to the code.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 arch/x86/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 59b7fc4..637a95b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -389,7 +389,7 @@ static unsigned long __init init_range_memory_mapping(
 	return mapped_ram_size;
 }
 
-/* (PUD_SHIFT-PMD_SHIFT)/2 */
+/* (PUD_SHIFT-PMD_SHIFT)/2+1 */
 #define STEP_SIZE_SHIFT 5
 void __init init_mem_mapping(void)
 {
-- 
1.8.0.1

