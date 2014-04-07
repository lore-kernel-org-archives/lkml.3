Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaDGPLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:11:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbaDGPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:10:50 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: Require x86-64 for automatic NUMA balancing
Date: Mon,  7 Apr 2014 16:10:41 +0100
Message-Id: <1396883443-11696-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396883443-11696-1-git-send-email-mgorman@suse.de>
References: <1396883443-11696-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automatic NUMA balancing currently depends on reusing the PROT_NONE
bit which has caused problems on Xen. In preparation for using one of
the unused physical address bits this patch requires x86-64 for automatic
NUMA balancing. 32-bit support for NUMA on x86 is no longer interesting
and the loss of automatic NUMA balancing support should be no surprise.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..084b1c1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,7 +26,7 @@ config X86
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
-	select ARCH_SUPPORTS_NUMA_BALANCING
+	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
 	select ARCH_SUPPORTS_INT128 if X86_64
 	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
-- 
1.8.4.5

