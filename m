Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaCEKAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:00:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32816 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaCEKAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:00:40 -0500
X-IronPort-AV: E=Sophos;i="4.97,591,1389715200"; 
   d="scan'208";a="9648694"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH tip] perf/x86/uncore: Add __init for uncore_cpumask_init().
Date: Wed, 5 Mar 2014 17:58:36 +0800
Message-Id: <1394013516-4964-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 17:57:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 17:57:58,
	Serialize complete at 2014/03/05 17:57:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 411cf180f introduce function uncore_cpumask_init() and it is only
called in __init intel_uncore_init(). But it is not marked with __init,
then the following warning is there when building.

WARNING: vmlinux.o(.text+0x2464a): Section mismatch in reference from the function uncore_cpumask_init() to the function .init.text:uncore_cpu_setup()
The function uncore_cpumask_init() references
the function __init uncore_cpu_setup().
This is often because uncore_cpumask_init lacks a __init
annotation or the annotation of uncore_cpu_setup is wrong.

This patch add __init for uncore_cpumask_init() function.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Paul Mackerras <paulus@samba.org>
cc: Ingo Molnar <mingo@redhat.com>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: Thomas Gleixner <tglx@linutronix.de>
cc: "H. Peter Anvin" <hpa@zytor.com>
cc: Stephane Eranian <eranian@google.com>
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
 
-- 
1.8.2.1

