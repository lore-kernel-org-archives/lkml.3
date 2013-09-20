Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3ITUUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:20:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab3ITUOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 27/93] arm64: perf: fix ARMv8 EVTYPE_MASK to include NSH bit
Date: Fri, 20 Sep 2013 13:08:22 -0700
Message-Id: <1379707768-1804-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 178cd9ce377232518ec17ff2ecab2e80fa60784c upstream.

This is a port of f2fe09b055e2 ("ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK
to include NSH bit") to arm64, which fixes the broken evtype mask to
include the NSH bit, allowing profiling at EL2.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index bb18b6e..a98ba4fd 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -784,7 +784,7 @@ static const unsigned armv8_pmuv3_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define	ARMV8_EVTYPE_MASK	0xc00000ff	/* Mask for writable bits */
+#define	ARMV8_EVTYPE_MASK	0xc80000ff	/* Mask for writable bits */
 #define	ARMV8_EVTYPE_EVENT	0xff		/* Mask for EVENT bits */
 
 /*
-- 
1.8.1.2

