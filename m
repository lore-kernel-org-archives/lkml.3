Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3CEC2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:28:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:18332 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab3CEC2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:28:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="scan'208";a="293621020"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [RFC PATCH v2 3/4] x86: tsc: Add support for new S3_NOTSTOP feature
Date: Tue,  5 Mar 2013 10:27:05 +0800
Message-Id: <1362450426-4232-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/tsc.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 4b9ea10..fb581c6 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -768,7 +768,8 @@ static cycle_t read_tsc(struct clocksource *cs)
 
 static void resume_tsc(struct clocksource *cs)
 {
-	clocksource_tsc.cycle_last = 0;
+	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
+		clocksource_tsc.cycle_last = 0;
 }
 
 static struct clocksource clocksource_tsc = {
@@ -939,6 +940,9 @@ static int __init init_tsc_clocksource(void)
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
+		clocksource_tsc.flags |= CLOCK_SOURCE_SUSPEND_NOTSTOP;
+
 	/*
 	 * Trust the results of the earlier calibration on systems
 	 * exporting a reliable TSC.
-- 
1.7.0.4

