Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3LMMN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:13:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50810 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3LMMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:23 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 3/8] x86: implement arch interface for scheduler domain setup
Date: Fri, 13 Dec 2013 12:11:23 +0000
Message-Id: <1386936688-29113-4-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:20.0585 (UTC) FILETIME=[6EF76790:01CEF7FC]
X-MC-Unique: 113121312112106201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCDY6S009934

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch provides the arch_sched_domain_info array for the x86 arch.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/x86/kernel/topology.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 649b010da00b..b9ddd4b50265 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -30,11 +30,23 @@
 #include <linux/mmzone.h>
 #include <linux/init.h>
 #include <linux/smp.h>
+#include <linux/sched.h>
 #include <linux/irq.h>
 #include <asm/cpu.h>
 
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
+arch_sched_domain_info_t arch_sched_domain_info[] = {
+#ifdef CONFIG_SCHED_SMT
+		{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES },
+#endif
+#ifdef CONFIG_SCHED_MC
+		{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
+#endif
+		{ cpu_cpu_mask, SD_PREFER_SIBLING },
+		{ NULL, },
+};
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 #ifdef CONFIG_BOOTPARAM_HOTPLUG_CPU0
-- 
1.7.9.5


