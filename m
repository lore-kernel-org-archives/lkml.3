Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3CFHAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:00:18 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34771 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab3CFHAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:00:15 -0500
Date: Tue, 5 Mar 2013 21:48:26 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        robert.richter@amd.com, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, benh@kernel.crashing.org
Subject: Re: [PATCH 5/6][v4]: perf: Create a sysfs entry for Power event
 format
Message-ID: <20130306054826.GA14627@us.ibm.com>
References: <20130123062201.GA13720@us.ibm.com>
 <20130123062613.GF13720@us.ibm.com>
 <20130226052646.GB21553@concordia>
 <20130226200343.GA21543@us.ibm.com>
 <20130227011725.GA5819@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227011725.GA5819@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030605-7182-0000-0000-000005A94F45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| I suspect Arnaldo was either waiting for an ACK from Ben, or was
| expecting Ben to take it?

Arnaldo, here is an updated patch. If it is acked by Paul Mackerras,
Michael Ellerman or Ben, will you add it to your tree so the whole
patchset comes from one place ?

Sukadev

---
>From 50c7a46f14083c0ed10d66b7aed66ba76e798550 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 5 Mar 2013 21:20:56 -0800
Subject: [PATCH] [PATCH 5/6][v4]: perf Create a sysfs format entry for Power7 events

Create a sysfs entry, '/sys/bus/event_source/devices/cpu/format/event'
which describes the format of the POWER7 PMU events.

This code is based on corresponding code in x86.

Changelog[v4]:  [Michael Ellerman, Paul Mckerras] The event format is different
		for other POWER cpus. So move the code to POWER7-specific,
		power7-pmu.c Also, the POWER7 format uses bits 0-19 not 0-20.

Changelog[v2]: [Jiri Osla] Use PMU_FORMAT_ATTR rather than duplicating code.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power7-pmu.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index b554879..3c475d6 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -420,7 +420,20 @@ static struct attribute_group power7_pmu_events_group = {
 	.attrs = power7_events_attr,
 };
 
+PMU_FORMAT_ATTR(event, "config:0-19");
+
+static struct attribute *power7_pmu_format_attr[] = {
+	&format_attr_event.attr,
+	NULL,
+};
+
+struct attribute_group power7_pmu_format_group = {
+	.name = "format",
+	.attrs = power7_pmu_format_attr,
+};
+
 static const struct attribute_group *power7_pmu_attr_groups[] = {
+	&power7_pmu_format_group,
 	&power7_pmu_events_group,
 	NULL,
 };
-- 
1.7.1

