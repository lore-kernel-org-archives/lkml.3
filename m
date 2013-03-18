Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab3CRK6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:58:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3CRK6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:58:42 -0400
Date: Mon, 18 Mar 2013 03:57:13 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-3bf7b07ece6e00747602938f68c1db8001b9925f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        mingo@redhat.com, paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, jolsa@redhat.com,
        robert.richter@amd.com, anton@au1.ibm.com, ak@linux.intel.com,
        tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, mingo@redhat.com,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, jolsa@redhat.com,
        robert.richter@amd.com, anton@au1.ibm.com, ak@linux.intel.com,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20130306054826.GA14627@us.ibm.com>
References: <20130306054826.GA14627@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/POWER7:
  Create a sysfs format entry for Power7 events
Git-Commit-ID: 3bf7b07ece6e00747602938f68c1db8001b9925f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:57:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bf7b07ece6e00747602938f68c1db8001b9925f
Gitweb:     http://git.kernel.org/tip/3bf7b07ece6e00747602938f68c1db8001b9925f
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Tue, 5 Mar 2013 21:48:26 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Mar 2013 17:01:04 -0300

perf/POWER7: Create a sysfs format entry for Power7 events

Create a sysfs entry, '/sys/bus/event_source/devices/cpu/format/event'
which describes the format of the POWER7 PMU events.

This code is based on corresponding code in x86.

Changelog[v4]:  [Michael Ellerman, Paul Mckerras] The event format is different
		for other POWER cpus. So move the code to POWER7-specific,
		power7-pmu.c Also, the POWER7 format uses bits 0-19 not 0-20.

Changelog[v2]: [Jiri Osla] Use PMU_FORMAT_ATTR rather than duplicating code.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Tested-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org
Link: http://lkml.kernel.org/r/20130306054826.GA14627@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/powerpc/perf/power7-pmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

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
