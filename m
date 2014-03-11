Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaCKMjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:39:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaCKMjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:39:05 -0400
Date: Tue, 11 Mar 2014 05:38:08 -0700
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-ef11dadb8373fcbe53bdd09ceb262b2f18da10c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, acme@ghostprotocols.net,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        acme@ghostprotocols.net, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <1394013516-4964-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1394013516-4964-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore:
  Add __init for uncore_cpumask_init()
Git-Commit-ID: ef11dadb8373fcbe53bdd09ceb262b2f18da10c5
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

Commit-ID:  ef11dadb8373fcbe53bdd09ceb262b2f18da10c5
Gitweb:     http://git.kernel.org/tip/ef11dadb8373fcbe53bdd09ceb262b2f18da10c5
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Wed, 5 Mar 2014 17:58:36 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:57:56 +0100

perf/x86/uncore: Add __init for uncore_cpumask_init()

Commit:

  411cf180fa00 perf/x86/uncore: fix initialization of cpumask

introduced the function uncore_cpumask_init(), which is only
called in __init intel_uncore_init(). But it is not marked
with __init, which produces the following warning:

	WARNING: vmlinux.o(.text+0x2464a): Section mismatch in reference from the function uncore_cpumask_init() to the function .init.text:uncore_cpu_setup()
	The function uncore_cpumask_init() references
	the function __init uncore_cpu_setup().
	This is often because uncore_cpumask_init lacks a __init
	annotation or the annotation of uncore_cpu_setup is wrong.

This patch marks uncore_cpumask_init() with __init.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1394013516-4964-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b262c61..5c2537a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -4229,7 +4229,7 @@ static int __init uncore_pmus_register(void)
 	return 0;
 }
 
-static void uncore_cpumask_init(void)
+static void __init uncore_cpumask_init(void)
 {
 	int cpu;
 
