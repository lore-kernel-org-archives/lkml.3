Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3CNKpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:45:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab3CNKh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 62/88] ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit
Date: Thu, 14 Mar 2013 10:35:55 +0000
Message-Id: <1363257381-15900-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f2fe09b055e2549de41fb107b34c60bac4a1b0cf upstream.

Masked out PMXEVTYPER.NSH means that we can't enable profiling at PL2,
regardless of the settings in the HDCR.

This patch fixes the broken mask.

Reported-by: Christoffer Dall <cdall@cs.columbia.edu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/perf_event_v7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index d3c5360..eff4c68 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -775,7 +775,7 @@ static const unsigned armv7_a7_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 /*
  * PMXEVTYPER: Event selection reg
  */
-#define	ARMV7_EVTYPE_MASK	0xc00000ff	/* Mask for writable bits */
+#define	ARMV7_EVTYPE_MASK	0xc80000ff	/* Mask for writable bits */
 #define	ARMV7_EVTYPE_EVENT	0xff		/* Mask for EVENT bits */
 
 /*
-- 
1.8.1.2

