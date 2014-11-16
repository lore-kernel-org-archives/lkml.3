Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaKPMfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:35:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35612 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbaKPMfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:35:08 -0500
Date: Sun, 16 Nov 2014 04:34:37 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-c0737ce453bdccd0d09aa4f916795533a4e02fef@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        ak@linux.intel.com, acme@kernel.org, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: ak@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, acme@kernel.org, mingo@kernel.org,
        tglx@linutronix.de
In-Reply-To: <1415062828-19759-2-git-send-email-andi@firstfloor.org>
References: <1415062828-19759-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel/uncore:
  Add scaling units to the EP iMC events
Git-Commit-ID: c0737ce453bdccd0d09aa4f916795533a4e02fef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0737ce453bdccd0d09aa4f916795533a4e02fef
Gitweb:     http://git.kernel.org/tip/c0737ce453bdccd0d09aa4f916795533a4e02fef
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 3 Nov 2014 17:00:26 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:41:52 +0100

perf/x86/intel/uncore: Add scaling units to the EP iMC events

Add scaling to MB/s to the memory controller read/write
events for Sandy/IvyBridge/Haswell-EP similar to how the client
does. This makes the events easier to use from the
standard perf tool.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1415062828-19759-2-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index f9ed429..745b158 100644
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
 
@@ -2036,7 +2040,11 @@ static struct intel_uncore_type hswep_uncore_ha = {
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
 
