Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbaEEIIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:08:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbaEEIIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078482"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 01/12 v1] CONFIG for CPU ConCurrency
Date: Mon,  5 May 2014 08:02:41 +0800
Message-Id: <1399248172-13871-2-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 arch/x86/Kconfig |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..9bfac8d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -797,6 +797,17 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config CPU_CONCURRENCY
+	bool "CPU ConCurency (CC)"
+	default n
+	depends on SMP
+	---help---
+	  CPU ConCurrency (CC) is a new CPU load metric that measures the CPU
+	  load by averaging the number of running tasks. Using CC, the scheduler
+	  can evaluate the load of CPUs and may consolidate workloads on CPUs in
+	  load balancing for power efficiency without sacrificing performance.
+	  If unsure say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
-- 
1.7.9.5

