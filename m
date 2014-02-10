Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaBJN3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:29:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaBJN3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:29:20 -0500
Date: Mon, 10 Feb 2014 05:28:32 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-69efsat90ibhnd577zy3z9gh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, junk@eslaf.co.uk, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, junk@eslaf.co.uk
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix Userspace RDPMC switch
Git-Commit-ID: 0e9f2204cfa6d79abe3e525ddf7c4ab5792cc751
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:28:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e9f2204cfa6d79abe3e525ddf7c4ab5792cc751
Gitweb:     http://git.kernel.org/tip/0e9f2204cfa6d79abe3e525ddf7c4ab5792cc751
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 5 Feb 2014 11:19:56 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:08:25 +0100

perf/x86: Fix Userspace RDPMC switch

The current code forgets to change the CR4 state on the current CPU.
Use on_each_cpu() instead of smp_call_function().

Reported-by: Mark Davies <junk@eslaf.co.uk>
Suggested-by: Mark Davies <junk@eslaf.co.uk>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: fweisbec@gmail.com
Link: http://lkml.kernel.org/n/tip-69efsat90ibhnd577zy3z9gh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1246b85..895604f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1826,7 +1826,7 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 
 	if (!!val != !!x86_pmu.attr_rdpmc) {
 		x86_pmu.attr_rdpmc = !!val;
-		smp_call_function(change_rdpmc, (void *)val, 1);
+		on_each_cpu(change_rdpmc, (void *)val, 1);
 	}
 
 	return count;
