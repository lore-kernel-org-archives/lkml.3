Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749Ab3DBJqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:46:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50962 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760998Ab3DBJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:45:59 -0400
Date: Tue, 2 Apr 2013 02:45:47 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-a63fcab45273174e665e6a8c9fa1a79a9046d0d5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1359040242-8269-10-git-send-email-eranian@google.com>
References: <1359040242-8269-10-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Export PEBS load latency threshold register to sysfs
Git-Commit-ID: a63fcab45273174e665e6a8c9fa1a79a9046d0d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:45:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a63fcab45273174e665e6a8c9fa1a79a9046d0d5
Gitweb:     http://git.kernel.org/tip/a63fcab45273174e665e6a8c9fa1a79a9046d0d5
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:33 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:16:49 -0300

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
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d5ea5a0..ae6096b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1781,6 +1781,8 @@ static void intel_pmu_flush_branch_stack(void)
 
 PMU_FORMAT_ATTR(offcore_rsp, "config1:0-63");
 
+PMU_FORMAT_ATTR(ldlat, "config1:0-15");
+
 static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -1791,6 +1793,7 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_cmask.attr,
 
 	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
+	&format_attr_ldlat.attr, /* PEBS load latency */
 	NULL,
 };
 
