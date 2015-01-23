Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbbAWMNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:13:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:3584 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbAWMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444169049"
Date: Fri, 23 Jan 2015 20:12:06 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [PATCH tip] hrtimer: __hrtimer_get_next_event() can be static
Message-ID: <20150123121206.GA4766@snb>
References: <201501232056.e6Qrox8m%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501232056.e6Qrox8m%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/time/hrtimer.c:444:9: sparse: symbol '__hrtimer_get_next_event' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index b663653..702dce8 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -441,7 +441,7 @@ static inline void debug_deactivate(struct hrtimer *timer)
 }
 
 #if defined(CONFIG_NO_HZ_COMMON) || defined(CONFIG_HIGH_RES_TIMERS)
-ktime_t __hrtimer_get_next_event(struct hrtimer_cpu_base *cpu_base)
+static ktime_t __hrtimer_get_next_event(struct hrtimer_cpu_base *cpu_base)
 {
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t expires, expires_next = { .tv64 = KTIME_MAX };
