Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3BASsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:48:11 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:38810 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3BASp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:45:59 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 2/6] cpufreq: Only query drivers that implement cpufreq_driver.target()
Date: Fri,  1 Feb 2013 10:45:37 -0800
Message-Id: <1359744343-18690-4-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

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
index 1c037f0..493cd50 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1794,7 +1794,7 @@ int cpufreq_update_policy(unsigned int cpu)
 
 	/* BIOS might change freq behind our back
 	  -> ask driver for current freq and notify governors about a change */
-	if (cpufreq_driver->get) {
+	if (cpufreq_driver->get && cpufreq_driver->target) {
 		policy.cur = cpufreq_driver->get(cpu);
 		if (!data->cur) {
 			pr_debug("Driver did not initialize current freq");
-- 
1.7.7.6

