Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaDOOmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:42:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaDOOlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:41:22 -0400
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86: Require x86-64 for automatic NUMA balancing
Date: Tue, 15 Apr 2014 15:41:15 +0100
Message-Id: <1397572876-1610-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1397572876-1610-1-git-send-email-mgorman@suse.de>
References: <1397572876-1610-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32-bit support for NUMA is an oddity on its own but with automatic NUMA
balancing on top there is a reasonable risk that the CPUPID information
cannot be stored in the page flags. This patch removes support for
automatic NUMA support on 32-bit x86.

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

