Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3LRKcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:32:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3LRKcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:32:52 -0500
Date: Wed, 18 Dec 2013 02:32:20 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-7fd565e27547c913b83b46d94662103be81a88ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1387225224-27799-2-git-send-email-eranian@google.com>
References: <1387225224-27799-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: enable Haswell Celeron RAPL support
Git-Commit-ID: 7fd565e27547c913b83b46d94662103be81a88ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:32:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fd565e27547c913b83b46d94662103be81a88ec
Gitweb:     http://git.kernel.org/tip/7fd565e27547c913b83b46d94662103be81a88ec
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 16 Dec 2013 21:20:23 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:21:32 +0100

perf/x86: enable Haswell Celeron RAPL support

Enable RAPL support for Haswell Celeron (model 69).

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: zheng.z.yan@intel.com
Cc: bp@alien8.de
Cc: vincent.weaver@maine.edu
Cc: maria.n.dimakopoulou@gmail.com
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1387225224-27799-2-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_rapl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index bf8e4a7..0e3754e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -615,6 +615,7 @@ static int __init rapl_pmu_init(void)
 	case 42: /* Sandy Bridge */
 	case 58: /* Ivy Bridge */
 	case 60: /* Haswell */
+	case 69: /* Haswell-Celeron */
 		rapl_cntr_mask = RAPL_IDX_CLN;
 		rapl_pmu_events_group.attrs = rapl_events_cln_attr;
 		break;
