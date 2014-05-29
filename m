Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbaE2OKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:10:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59412 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933298AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        Arvind.Chauhan@arm.com, linaro-networking@linaro.org,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/103] tick-common: Fix wrong check in tick_check_replacement()
Date: Thu, 29 May 2014 15:48:12 +0200
Message-Id: <39760567d0146b23580d41db26b60cd9f873a4df.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 521c42990e9d561ed5ed9f501f07639d0512b3c9 upstream.

tick_check_replacement() returns if a replacement of clock_event_device is
possible or not. It does this as the first check:

	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
		return false;

Thats wrong. tick_check_percpu() returns true when the device is
useable. Check for false instead.

[ tglx: Massaged changelog ]

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: Arvind.Chauhan@arm.com
Cc: linaro-networking@linaro.org
Link: http://lkml.kernel.org/r/486a02efe0246635aaba786e24b42d316438bf3b.1397537987.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/time/tick-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 64522ecdfe0e..271ce26faa21 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -260,7 +260,7 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 bool tick_check_replacement(struct clock_event_device *curdev,
 			    struct clock_event_device *newdev)
 {
-	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
+	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
 		return false;
 
 	return tick_check_preferred(curdev, newdev);
-- 
1.9.3

