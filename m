Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761213Ab3D3QsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:48:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760981Ab3D3QsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:48:16 -0400
Date: Tue, 30 Apr 2013 09:47:54 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-9a6bc14350b130427725f33e371e86212fa56c85@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        eranian@gmail.com, vincent.weaver@maine.edu, stable@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, eranian@gmail.com, vincent.weaver@maine.edu,
        stable@kernel.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1304291549320.15827@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1304291549320.15827@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Add support for IvyBridge model 58 Uncore
Git-Commit-ID: 9a6bc14350b130427725f33e371e86212fa56c85
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

Commit-ID:  9a6bc14350b130427725f33e371e86212fa56c85
Gitweb:     http://git.kernel.org/tip/9a6bc14350b130427725f33e371e86212fa56c85
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Mon, 29 Apr 2013 15:52:27 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 10:56:45 +0200

perf/x86/intel: Add support for IvyBridge model 58 Uncore

According to Intel Vol3b 18.9, the IvyBridge model 58 uncore is
the same as that of SandyBridge.

I've done some simple tests and with this patch things seem to
work on my mac-mini.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@gmail.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1304291549320.15827@vincent-weaver-1.um.maine.edu
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0d5ec6d..22ebaa8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2853,6 +2853,7 @@ static int __init uncore_cpu_init(void)
 		msr_uncores = nhm_msr_uncores;
 		break;
 	case 42: /* Sandy Bridge */
+	case 58: /* Ivy Bridge */
 		if (snb_uncore_cbox.num_boxes > max_cores)
 			snb_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snb_msr_uncores;
