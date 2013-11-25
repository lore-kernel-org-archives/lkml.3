Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3KYDFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 22:05:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:17662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab3KYDFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 22:05:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,765,1378882800"; 
   d="scan'208";a="433054497"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org, hg197@gmx.de
Cc: Lan Tianyu <tianyu.lan@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Cpufreq: Change sysfs interface cpuinfo_cur_freq access privilege
Date: Mon, 25 Nov 2013 10:53:38 +0800
Message-Id: <1385348018-30525-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, cpuinfo_cur_freq is only accessible for root user while
other cpufreq sysfs interfaces(E,G scaling_cur_freq) are available
to ordinary user. This seems make no sense. This patch is to change
it.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/cpufreq/cpufreq.c | 2 +-
 include/linux/cpufreq.h   | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 02d534d..1926465 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -605,7 +605,7 @@ static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
 	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
 }
 
-cpufreq_freq_attr_ro_perm(cpuinfo_cur_freq, 0400);
+cpufreq_freq_attr_ro(cpuinfo_cur_freq);
 cpufreq_freq_attr_ro(cpuinfo_min_freq);
 cpufreq_freq_attr_ro(cpuinfo_max_freq);
 cpufreq_freq_attr_ro(cpuinfo_transition_latency);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5bd6ab9..b4bb677 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -166,10 +166,6 @@ struct freq_attr {
 static struct freq_attr _name =			\
 __ATTR(_name, 0444, show_##_name, NULL)
 
-#define cpufreq_freq_attr_ro_perm(_name, _perm)	\
-static struct freq_attr _name =			\
-__ATTR(_name, _perm, show_##_name, NULL)
-
 #define cpufreq_freq_attr_rw(_name)		\
 static struct freq_attr _name =			\
 __ATTR(_name, 0644, show_##_name, store_##_name)
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

