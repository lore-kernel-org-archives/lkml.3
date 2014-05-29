Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749AbaE2FjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:39:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbaE2Eew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linaro-kernel@lists.linaro.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: [PATCH 3.14 017/140] tick-common: Fix wrong check in tick_check_replacement()
Date: Wed, 28 May 2014 21:32:36 -0700
Message-Id: <20140529043051.525154521@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -276,7 +276,7 @@ static bool tick_check_preferred(struct
 bool tick_check_replacement(struct clock_event_device *curdev,
 			    struct clock_event_device *newdev)
 {
-	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
+	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
 		return false;
 
 	return tick_check_preferred(curdev, newdev);


