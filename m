Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3LMUBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:01:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3LMUBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:01:16 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/4] x86: mm: Change tlb_flushall_shift for IvyBridge
Date: Fri, 13 Dec 2013 20:01:09 +0000
Message-Id: <1386964870-6690-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386964870-6690-1-git-send-email-mgorman@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a large performance regression that was bisected to commit 611ae8e3
(x86/tlb: enable tlb flush range support for x86). This patch simply changes
the default balance point between a local and global flush for IvyBridge.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/kernel/cpu/intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index dc1ec0d..2d93753 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -627,7 +627,7 @@ static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 		tlb_flushall_shift = 5;
 		break;
 	case 0x63a: /* Ivybridge */
-		tlb_flushall_shift = 1;
+		tlb_flushall_shift = 2;
 		break;
 	default:
 		tlb_flushall_shift = 6;
-- 
1.8.4

