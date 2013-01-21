Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab3AUGi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:38:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:39002 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab3AUGiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:38:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="scan'208";a="193316334"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>
Subject: [RFC PATCH 3/5] x86: tsc: Add support for new S3_NOTSTOP feature
Date: Mon, 21 Jan 2013 14:38:43 +0800
Message-Id: <1358750325-21217-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/tsc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 06ccb50..4cc33ca 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -767,7 +767,8 @@ static cycle_t read_tsc(struct clocksource *cs)
 
 static void resume_tsc(struct clocksource *cs)
 {
-	clocksource_tsc.cycle_last = 0;
+	if (!boot_cpu_has(X86_FEATURE_TSC_S3_NOTSTOP))
+		clocksource_tsc.cycle_last = 0;
 }
 
 static struct clocksource clocksource_tsc = {
@@ -938,6 +939,9 @@ static int __init init_tsc_clocksource(void)
 		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_TSC_S3_NOTSTOP))
+		clocksource_tsc.flags |= CLOCK_SOURCE_SUSPEND_NOTSTOP;
+
 	/*
 	 * Trust the results of the earlier calibration on systems
 	 * exporting a reliable TSC.
-- 
1.7.9.5

