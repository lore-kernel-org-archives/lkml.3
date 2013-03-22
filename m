Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab3CVHQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 03:16:41 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54462 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932853Ab3CVHQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 03:16:39 -0400
Message-ID: <514C0555.1010806@semaphore.gr>
Date: Fri, 22 Mar 2013 09:16:37 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH linux-pm] cpufreq: governors: Fix calculation of wall time
 in get_cpu_idle_time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 8755a8ae31ba213db196324011a0da2a85807f25 the wall in
get_cpu_idle_time is not calculated, when we use ondemand with
io_is_busy = 1, preventing the CPU to increase to max frequency.

Properly, calculate wall time when we use io_is_busy.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_governor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index b49d45d..41e5e56 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -53,7 +53,7 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 
 u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
 {
-	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
+	u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
 
 	if (idle_time == -1ULL)
 		return get_cpu_idle_time_jiffy(cpu, wall);
-- 
1.8.1.4

