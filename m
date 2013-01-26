Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3AZMVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:21:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3AZMVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:21:14 -0500
Date: Sat, 26 Jan 2013 04:20:16 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-fc7d3e64651e4de80262e48a3fb75128fffb8ef3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        bp@suse.de
In-Reply-To: <1359135967-31401-1-git-send-email-bp@alien8.de>
References: <1359135967-31401-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86] perf/x86: Fix type to address build warning
Git-Commit-ID: fc7d3e64651e4de80262e48a3fb75128fffb8ef3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 26 Jan 2013 04:20:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc7d3e64651e4de80262e48a3fb75128fffb8ef3
Gitweb:     http://git.kernel.org/tip/fc7d3e64651e4de80262e48a3fb75128fffb8ef3
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 25 Jan 2013 18:46:07 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 19:32:02 +0100

perf/x86: Fix type to address build warning

Fix this one:

 arch/x86/kernel/cpu/perf_event.c: In function ‘init_hw_perf_events’:
 arch/x86/kernel/cpu/perf_event.c:1508:7: warning: assignment from incompatible pointer type [enabled by default]
 arch/x86/kernel/cpu/perf_event.c:1510:31: warning: assignment from incompatible pointer type [enabled by default]

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1359135967-31401-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1e2519d..c6ef37a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1503,7 +1503,7 @@ static int __init init_hw_perf_events(void)
 		filter_events(x86_pmu_events_group.attrs);
 
 	if (x86_pmu.cpu_events) {
-		struct attribute *tmp;
+		struct attribute **tmp;
 
 		tmp = merge_attr(x86_pmu_events_group.attrs, x86_pmu.cpu_events);
 		if (!WARN_ON(!tmp))
