Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3BFRCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:02:45 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51321 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab3BFRCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:02:39 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 2/5] cpufreq: Only call cpufreq_out_of_sync() for driver that implement cpufreq_driver.target()
Date: Wed,  6 Feb 2013 09:02:09 -0800
Message-Id: <1360170133-5066-3-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Scaling drivers that implement cpufreq_driver.setpolicy() have
internal governors that do not signal changes via
cpufreq_notify_transition() so the frequncy in the policy will almost
certainly be different than the current frequncy.  Only call
cpufreq_out_of_sync() when the underlying driver implements
cpufreq_driver.target()

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index bb45f93..0ba0344 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1798,7 +1798,7 @@ int cpufreq_update_policy(unsigned int cpu)
 			pr_debug("Driver did not initialize current freq");
 			data->cur = policy.cur;
 		} else {
-			if (data->cur != policy.cur)
+			if (data->cur != policy.cur && driver->target)
 				cpufreq_out_of_sync(cpu, data->cur,
 								policy.cur);
 		}
-- 
1.7.7.6

