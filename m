Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab3GSPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:05:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:16024 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3GSPFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,702,1367996400"; 
   d="scan'208";a="367962311"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, eranian@google.com
Subject: [PATCH] perf, x86: Enable PEBS mode automatically for mem-{loads,stores} v4
Date: Fri, 19 Jul 2013 08:05:49 -0700
Message-Id: <1374246349-9664-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[The patch to enable this in the user tools has been sent separately]

With the earlier patches to automatically try cpu// and add
a precise sys attribute, we can now enable PEBS for the mem-loads,
mem-stores events everywhere.

This allows to use

perf record -e mem-loads ...

instead of

perf record -e cpu/mem-loads/p ...

Always use precise=2 even though it is costly pre-Haswell

Cc: eranian@google.com
v2: Different white space
v3: Always use precise=2, as people seem to think overhead doesn't matter.
v4: Longer lines
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fbc9210..1871866 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -176,9 +176,9 @@ static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
-EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
-EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
-EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
+EVENT_ATTR_STR(mem-loads,  mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3,precise=2");
+EVENT_ATTR_STR(mem-loads,  mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3,precise=2");
+EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2,precise=2");
 
 struct attribute *nhm_events_attrs[] = {
 	EVENT_PTR(mem_ld_nhm),
@@ -2034,8 +2034,9 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
-EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
-EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
+EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,
+		"event=0xcd,umask=0x1,ldlat=3,precise=2");
+EVENT_ATTR_STR(mem-stores,     mem_st_hsw,  "event=0xd0,umask=0x82,precise=2")
 
 static struct attribute *hsw_events_attrs[] = {
 	EVENT_PTR(mem_ld_hsw),
-- 
1.8.1.4

