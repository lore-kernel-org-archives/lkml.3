Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3CFHUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:20:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:37047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3CFHTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:19:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,793,1355126400"; 
   d="scan'208";a="299868709"
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 2/5] clocksource: Add new feature flag CLOCK_SOURCE_SUSPEND_NONSTOP
Date: Wed,  6 Mar 2013 15:17:48 +0800
Message-Id: <1362554271-22382-3-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some x86 processors have a TSC clocksource, which continues to run
even when system is suspended. Also most OMAP platforms have a
32 KHz timer which has similar capability. Add a feature flag so that
it could be utilized.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 include/linux/clocksource.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 27cfda4..aa7032c 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -206,6 +206,7 @@ struct clocksource {
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 #define CLOCK_SOURCE_UNSTABLE			0x40
+#define CLOCK_SOURCE_SUSPEND_NONSTOP		0x80
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
-- 
1.7.9.5

