Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaDOSpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:45:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbaDOSpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:45:47 -0400
Date: Tue, 15 Apr 2014 11:45:32 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-521c42990e9d561ed5ed9f501f07639d0512b3c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <486a02efe0246635aaba786e24b42d316438bf3b.1397537987.git.viresh.kumar@linaro.org>
References: <486a02efe0246635aaba786e24b42d316438bf3b.1397537987.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick-common:
  Fix wrong check in tick_check_replacement()
Git-Commit-ID: 521c42990e9d561ed5ed9f501f07639d0512b3c9
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

Commit-ID:  521c42990e9d561ed5ed9f501f07639d0512b3c9
Gitweb:     http://git.kernel.org/tip/521c42990e9d561ed5ed9f501f07639d0512b3c9
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 15 Apr 2014 10:54:37 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 15 Apr 2014 20:26:44 +0200

tick-common: Fix wrong check in tick_check_replacement()

tick_check_replacement() returns if a replacement of clock_event_device is
possible or not. It does this as the first check:

	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
		return false;

Thats wrong. tick_check_percpu() returns true when the device is
useable. Check for false instead.

[ tglx: Massaged changelog ]

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: <stable@vger.kernel.org> # v3.11+
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: Arvind.Chauhan@arm.com
Cc: linaro-networking@linaro.org
Link: http://lkml.kernel.org/r/486a02efe0246635aaba786e24b42d316438bf3b.1397537987.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0156612..0a0608e 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -276,7 +276,7 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 bool tick_check_replacement(struct clock_event_device *curdev,
 			    struct clock_event_device *newdev)
 {
-	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
+	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
 		return false;
 
 	return tick_check_preferred(curdev, newdev);
