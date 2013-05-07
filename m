Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3EGPVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:21:10 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50562 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3EGPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:20:57 -0400
From: dirk.brandewie@gmail.com
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 6/6] cpufreq/intel_pstate: remove #ifdef MODULE compile fence
Date: Tue,  7 May 2013 08:20:30 -0700
Message-Id: <1367940030-19311-7-git-send-email-dirk.j.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
References: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

The driver can no longer be built as a module remove the compile fence
around cpufreq tracing call.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c7bd91f..50a29df 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -391,9 +391,8 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 	if (pstate == cpu->pstate.current_pstate)
 		return;
 
-#ifndef MODULE
 	trace_cpu_frequency(pstate * 100000, cpu->cpu);
-#endif
+
 	cpu->pstate.current_pstate = pstate;
 	wrmsrl(MSR_IA32_PERF_CTL, pstate << 8);
 
-- 
1.7.7.6

