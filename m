Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219Ab3BZJoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:44:21 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41644 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760186Ab3BZJoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:44:18 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, trenn@suse.de
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC] cpufreq: governor: Set MIN_LATENCY_MULTIPLIER to 20
Date: Tue, 26 Feb 2013 15:13:32 +0530
Message-Id: <472e2bac1fc4a2589651beddbfaf6da53500d12e.1361871582.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 26 Feb 2013 09:44:14.0139 (UTC) FILETIME=[D63320B0:01CE1405]
X-MC-Unique: 113022609441600301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1Q9ikKi030159

Currently MIN_LATENCY_MULTIPLIER is set defined as 100 and so on a system with
transition latency of 1 ms, the minimum sampling time comes to be around 100 ms.
That is quite big if you want to get better performance for your system.

Redefine MIN_LATENCY_MULTIPLIER to 20 so that we can support 20ms sampling rate
for such platforms.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

Hi Guys,

I really don't know how this figure (100) came initially, but we really need to
have 20ms support for my platform: ARM TC2.

Pushed here:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-fixes

 drivers/cpufreq/cpufreq_governor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index d2ac911..adb8e30 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -34,7 +34,7 @@
  */
 #define MIN_SAMPLING_RATE_RATIO			(2)
 #define LATENCY_MULTIPLIER			(1000)
-#define MIN_LATENCY_MULTIPLIER			(100)
+#define MIN_LATENCY_MULTIPLIER			(20)
 #define TRANSITION_LATENCY_LIMIT		(10 * 1000 * 1000)
 
 /* Ondemand Sampling types */
-- 
1.7.12.rc2.18.g61b472e


