Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaKDBAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:00:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:44356 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaKDBAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:00:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,310,1413270000"; 
   d="scan'208";a="625920569"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] perf, x86: Add scaling units to the EP iMC events
Date: Mon,  3 Nov 2014 17:00:26 -0800
Message-Id: <1415062828-19759-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415062828-19759-1-git-send-email-andi@firstfloor.org>
References: <1415062828-19759-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add scaling to MB/s to the memory controller read/write
events for Sandy/IvyBridge/Haswell-EP similar to how the client
does. This makes the events easier to use from the
standard perf tool.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 22c6272..286c692 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -449,7 +449,11 @@ static struct attribute *snbep_uncore_qpi_formats_attr[] = {
 static struct uncore_event_desc snbep_uncore_imc_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0xff,umask=0x00"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.unit, "MiB"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.unit, "MiB"),
 	{ /* end: all zeroes */ },
 };
 
@@ -2009,7 +2013,11 @@ static struct intel_uncore_type hswep_uncore_ha = {
 static struct uncore_event_desc hswep_uncore_imc_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0x00,umask=0x00"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.unit, "MiB"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.unit, "MiB"),
 	{ /* end: all zeroes */ },
 };
 
-- 
1.9.3

