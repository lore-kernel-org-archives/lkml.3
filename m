Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3CZRwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:52:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3CZRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:19 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NVMjkpjR0x8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=QssMufGXbkwA:10 a=J1Y8HTJGAAAA:8 a=1XWaLZrsAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=4N9Db7Z2_RYA:10 a=UTB_XpHje0EA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173612.435548786@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 79/86] sparc64: Fix gfp_flags setting in tsb_grow().
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0079-sparc64-Fix-gfp_flags-setting-in-tsb_grow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 95a2fea6fbb81f56e2ecb60ef0c31e075d6a8995 ]

We should "|= more_flags" rather than "= more_flags".

Reported-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/mm/tsb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index c52add7..7c2d9ac 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -331,7 +331,7 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 retry_tsb_alloc:
 	gfp_flags = GFP_KERNEL;
 	if (new_size > (PAGE_SIZE * 2))
-		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
+		gfp_flags |= __GFP_NOWARN | __GFP_NORETRY;
 
 	new_tsb = kmem_cache_alloc_node(tsb_caches[new_cache_index],
 					gfp_flags, numa_node_id());
-- 
1.7.10.4


