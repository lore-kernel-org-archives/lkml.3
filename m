Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3AYWeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:34:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:48890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab3AYWd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="252629029"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/18] perf, x86: Add a Haswell precise instructions event v2
Date: Fri, 25 Jan 2013 14:33:10 -0800
Message-Id: <1359153192-13409-17-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a instructions-p event alias that uses the PDIR randomized instruction
retirement event. This is useful to avoid some systematic sampling shadow
problems. Normally PEBS sampling has a systematic shadow. With PDIR
enabled the hardware adds some randomization that statistically avoids
this problem. In this sense, it's more precise over a whole sampling
interval, but an individual sample can be less precise. But since we
sample overall it's a more precise event.

This could be used before using the explicit event code syntax, but it's easier
and more user friendly to use with an "instructions-p" alias. I expect
this will eventually become a common use case.

Right now for Haswell, will add to Ivy Bridge later too.

v2: Use new sysfs infrastructure
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 022246a..fa20a19 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2027,6 +2027,7 @@ EVENT_ATTR_STR(cycles-t,       cycles_t,       "event=0x3c,intx=1");
 EVENT_ATTR_STR(cycles-ct,      cycles_ct,      "event=0x3c,intx=1,intx_cp=1");
 EVENT_ATTR_STR(instructions-t, instructions_t, "event=0xc0,intx=1");
 EVENT_ATTR_STR(instructions-ct,instructions_ct,"event=0xc0,intx=1,intx_cp=1");
+EVENT_ATTR_STR(instructions-p, instructions_p, "event=0xc0,umask=0x01,precise=2");
 
 static struct attribute *hsw_events_attrs[] = {
 	EVENT_PTR(tx_start),
@@ -2047,6 +2048,7 @@ static struct attribute *hsw_events_attrs[] = {
 	EVENT_PTR(cycles_ct),
 	EVENT_PTR(instructions_t),
 	EVENT_PTR(instructions_ct),
+	EVENT_PTR(instructions_p),
 	NULL
 };
 
-- 
1.7.7.6

