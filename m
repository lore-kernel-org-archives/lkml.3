Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3CDWOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:14:41 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:47301 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932378Ab3CDWOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:14:39 -0500
Message-ID: <51351CC3.4010301@semaphore.gr>
Date: Tue, 05 Mar 2013 00:14:27 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] cpufreq: conservative: Fix sampling_down_factor
 functionality
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sampling_down_factor tunable is unused since commit
8e677ce83bf41ba9c74e5b6d9ee60b07d4e5ed93 (4 years ago).

This patch restores the original functionality.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_conservative.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 4fd0006..4b27c21 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -87,6 +87,12 @@ static void cs_check_cpu(int cpu, unsigned int load)
                return;
        }

+       /* if sampling_down_factor is active break out early */
+       if (++dbs_info->down_skip < cs_tuners.sampling_down_factor)
+               return;
+
+       dbs_info->down_skip = 0;
+
        /*
         * The optimal frequency is the frequency that is the lowest that can
         * support the current CPU usage without triggering the up policy. To be
-- 
1.8.1.4


