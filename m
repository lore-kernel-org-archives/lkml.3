Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3AYMXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:23:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3AYMXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:23:51 -0500
Date: Fri, 25 Jan 2013 04:23:34 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-5a54b18a9e9c77ebd1d30d4544e4f936fcafa6b9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1359040242-8269-10-git-send-email-eranian@google.com>
References: <1359040242-8269-10-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86] perf/x86:
  Export PEBS load latency threshold register to sysfs
Git-Commit-ID: 5a54b18a9e9c77ebd1d30d4544e4f936fcafa6b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:23:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a54b18a9e9c77ebd1d30d4544e4f936fcafa6b9
Gitweb:     http://git.kernel.org/tip/5a54b18a9e9c77ebd1d30d4544e4f936fcafa6b9
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:33 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 10:19:04 +0100

perf/x86: Export PEBS load latency threshold register to sysfs

Make the PEBS Load Latency threshold register layout
and encoding visible to user level tools.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-10-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f30027a..4ee1211 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1756,6 +1756,8 @@ static void intel_pmu_flush_branch_stack(void)
 
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
 
+PMU_FORMAT_ATTR(ldlat, "config1:0-15");
+
 static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -1766,6 +1768,7 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_cmask.attr,
 
 	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	&format_attr_ldlat.attr, /* PEBS load latency */
 	NULL,
 };
 
