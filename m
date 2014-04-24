Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaDXJWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:22:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaDXI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 155/182] tick-common: Fix wrong check in tick_check_replacement()
Date: Thu, 24 Apr 2014 09:51:20 +0100
Message-Id: <1398329507-5911-156-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/tick-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 64522ec..271ce26 100644
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
1.9.1

