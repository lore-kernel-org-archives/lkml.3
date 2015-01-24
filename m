Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbbAXKBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 05:01:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAXKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 05:00:57 -0500
Date: Sat, 24 Jan 2015 02:00:28 -0800
From: tip-bot for kbuild test robot <tipbot@zytor.com>
Message-ID: <tip-4ebbda5251374d532ba8939de4241d769d1420b6@git.kernel.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@kernel.org,
        hpa@zytor.com, fengguang.wu@intel.com
Reply-To: fengguang.wu@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20150123121206.GA4766@snb>
References: <20150123121206.GA4766@snb>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hrtimer: Make __hrtimer_get_next_event() static
Git-Commit-ID: 4ebbda5251374d532ba8939de4241d769d1420b6
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

Commit-ID:  4ebbda5251374d532ba8939de4241d769d1420b6
Gitweb:     http://git.kernel.org/tip/4ebbda5251374d532ba8939de4241d769d1420b6
Author:     kbuild test robot <fengguang.wu@intel.com>
AuthorDate: Fri, 23 Jan 2015 20:12:06 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 24 Jan 2015 10:53:36 +0100

hrtimer: Make __hrtimer_get_next_event() static

kernel/time/hrtimer.c:444:9: sparse: symbol '__hrtimer_get_next_event' was not declared. Should it be static?

Fixes: 9bc7491906b4 hrtimer: Prevent stale expiry time in hrtimer_interrupt()
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: kbuild-all@01.org
Link: http://lkml.kernel.org/r/20150123121206.GA4766@snb
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index b67ebea..ce8221a 100644
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
