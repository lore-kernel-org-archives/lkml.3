Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3A0APj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:15:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55487 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011Ab3A0APf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:15:35 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH] x86, numa: Use __pa_nodebug instead
Date: Sun, 27 Jan 2013 01:18:21 +0100
Message-Id: <1359245901-8512-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... and fix the following warning:

arch/x86/mm/numa.c: In function ‘setup_node_data’:
arch/x86/mm/numa.c:222:3: warning: passing argument 1 of ‘__phys_addr_nodebug’ makes integer from pointer without a cast [enabled by default]
In file included from /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/page.h:11:0,
                 from /home/boris/w/kernel/linux-2.6/arch/x86/include/asm/thread_info.h:11,
                 from include/linux/thread_info.h:54,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/mm.h:8,
                 from arch/x86/mm/numa.c:3:
/home/boris/w/kernel/linux-2.6/arch/x86/include/asm/page_64.h:12:29: note: expected ‘long unsigned int’ but argument is of type ‘void *’

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---
 arch/x86/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 76604eb9e4b0..b2313c6739f5 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -219,7 +219,7 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 */
 	nd = alloc_remap(nid, nd_size);
 	if (nd) {
-		nd_pa = __phys_addr_nodebug(nd);
+		nd_pa = __pa_nodebug(nd);
 		remapped = true;
 	} else {
 		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
-- 
1.8.1.rc3

