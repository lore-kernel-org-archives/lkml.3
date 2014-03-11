Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaCKFTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:19:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51414 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaCKFTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:19:44 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9676541"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, tglx@linutronix.de, hpa@zytor.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH for-tip V2] perf/x86/uncore: Add __init for uncore_cpumask_init().
Date: Tue, 11 Mar 2014 13:14:55 +0800
Message-Id: <1394514895-11122-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <CABPqkBR567Gb53z==FTjcfC2mKK6cruTPURjNXM+3ZUwAv24rw@mail.gmail.com>
References: <CABPqkBR567Gb53z==FTjcfC2mKK6cruTPURjNXM+3ZUwAv24rw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 13:14:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 13:16:51,
	Serialize complete at 2014/03/11 13:16:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 411cf180f introduce function uncore_cpumask_init() and it calls uncore_cpu_setup()
which is marked as __init. But it is not marked with __init, then the following warning
is there when building.

WARNING: vmlinux.o(.text+0x2464a): Section mismatch in reference from the function uncore_cpumask_init() to the function .init.text:uncore_cpu_setup()
The function uncore_cpumask_init() references
the function __init uncore_cpu_setup().
This is often because uncore_cpumask_init lacks a __init
annotation or the annotation of uncore_cpu_setup is wrong.

As function uncore_cpumask_init() is only called by __init intel_uncore_init(), then we can
free it after system initialization.

This patch add __init for uncore_cpumask_init() function.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Acked-by: Stephane Eranian <eranian@google.com>
---
Changlogs:
	-v1:
	   Add more commit message for this patch.

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

