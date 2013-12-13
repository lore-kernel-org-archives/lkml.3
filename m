Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3LMML1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:11:27 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50790 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3LMMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:23 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 2/8] arm: implement arch interface for scheduler domain setup
Date: Fri, 13 Dec 2013 12:11:22 +0000
Message-Id: <1386936688-29113-3-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:20.0147 (UTC) FILETIME=[6EB49230:01CEF7FC]
X-MC-Unique: 113121312112102401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCBcr3009901

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch provides the arch_sched_domain_info array for the ARM arch.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/arm/kernel/topology.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 85a87370f144..0be2685743ff 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -25,6 +25,14 @@
 #include <asm/cputype.h>
 #include <asm/topology.h>
 
+arch_sched_domain_info_t arch_sched_domain_info[] = {
+#ifdef CONFIG_SCHED_MC
+		{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
+#endif
+		{ cpu_cpu_mask, SD_PREFER_SIBLING },
+		{ NULL, },
+};
+
 /*
  * cpu power scale management
  */
-- 
1.7.9.5


