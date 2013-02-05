Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3BESZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:25:56 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:41409 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab3BESY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:24:26 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 3/7] cpufreq: Only query drivers that implement cpufreq_driver.target()
Date: Tue,  5 Feb 2013 10:24:02 -0800
Message-Id: <1360088646-19104-4-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Scaling drivers that implement cpufreq_driver.setpolicy() have
internal governors and may/will change the current operating frequency
very frequently this will cause cpufreq_out_of_sync() to be called
every time. Only call cpufreq_driver.get() for drivers that implement
cpufreq_driver.target()

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 96bc302..d8daa4b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1787,7 +1787,7 @@ int cpufreq_update_policy(unsigned int cpu)
 
 	/* BIOS might change freq behind our back
 	  -> ask driver for current freq and notify governors about a change */
-	if (cpufreq_driver->get) {
+	if (cpufreq_driver->get && cpufreq_driver->target) {
 		policy.cur = cpufreq_driver->get(cpu);
 		if (!data->cur) {
 			pr_debug("Driver did not initialize current freq");
-- 
1.7.7.6

