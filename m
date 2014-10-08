Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaJHHtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:49:43 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35584 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaJHHtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:49:31 -0400
From: Mike Turquette <mturquette@linaro.org>
To: viresh.kumar@linaro.org
Cc: thomas.petazzoni@free-electrons.com, rjw@rjwysocki.net,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        shawn.guo@linaro.org, sboyd@codeaurora.org,
        linux-arm-msm@vger.kernel.org, spk.linux@gmail.com,
        pramod.gurav@smartplayin.com, rob.herring@linaro.org,
        ezequiel.garcia@free-electrons.com, tawfik@marvell.com,
        nadavh@marvell.com, alior@marvell.com, morten.rasmussen@arm.com,
        dietmar.eggemann@arm.com, vincent.guittot@linaro.org,
        nicolas.pitre@linaro.org, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 2/2] cpufreq: new function to query driver for flags
Date: Wed,  8 Oct 2014 00:48:54 -0700
Message-Id: <1412754534-14068-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412754534-14068-1-git-send-email-mturquette@linaro.org>
References: <CAKohpo=7q9bDcHRxLehNLX6A2idGxUy3jEWvQ+EGbKOQG-MH2g@mail.gmail.com>
 <1412754534-14068-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases for CPUfreq driver flags to be exposed outside of the
CPUfreq core code. In particular the CPUFREQ_NO_SLEEP flag can be used
by CPUfreq governors to optimize when and how they call that drivers
.target callback. In fact this knowledge is a requirement for the
on-going work to initiate cpu frequency transitions from the scheduler.

This patch implements a simple function to return the CPUfreq driver
flags. While currently the flags are a u8, that could grow at a future
date and cpufreq_driver_get_flags returns an int. Additionally the
function needs to return an error in case no driver is registered.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9b471b2..f3b9042 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1980,6 +1980,15 @@ int cpufreq_driver_target(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 
+int cpufreq_driver_get_flags(void)
+{
+	if (!cpufreq_driver)
+		return -ENODEV;
+
+	return cpufreq_driver->flags;
+}
+EXPORT_SYMBOL_GPL(cpufreq_driver_get_flags);
+
 /*
  * when "event" is CPUFREQ_GOV_LIMITS
  */
-- 
1.8.3.2

