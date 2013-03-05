Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab3CEC2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:28:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:42044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776Ab3CEC2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:28:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="scan'208";a="293621018"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [RFC PATCH v2 2/4] clocksource: Add new feature flag CLOCK_SOURCE_SUSPEND_NOTSTOP
Date: Tue,  5 Mar 2013 10:27:04 +0800
Message-Id: <1362450426-4232-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some x86 processors have a TSC clocksource, which continue to work when
system is suspend. Add a feature flag so that it could be utilized.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 include/linux/clocksource.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 27cfda4..5dee330 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -206,6 +206,7 @@ struct clocksource {
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 #define CLOCK_SOURCE_UNSTABLE			0x40
+#define CLOCK_SOURCE_SUSPEND_NOTSTOP		0x80
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
-- 
1.7.0.4

