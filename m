Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab3GDPSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 11:18:04 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9274 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3GDPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 11:17:58 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-03-51d592248f5f
From: Konstantin Krivyakin <k.krivyakin@samsung.com>
To: k.krivyakin@samsung.com, i.zhbanov@samsung.com, e.voevodin@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/3] Add interface to receive current cpu power
Date: Thu, 04 Jul 2013 19:17:17 +0400
Message-id: <1372951039-10375-2-git-send-email-k.krivyakin@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
References: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t/xa7oqk64GGmztYrJYe66dyWLF1SOM
	FlMXHma3ONv0ht3i8q45bA6sHn1bVjF6fN4kF8AUxWWTkpqTWZZapG+XwJXxbvJH5oJVAhUP
	JqxjbWDs4+1i5OSQEDCRuLJjLzOELSZx4d56ti5GLg4hgaWMEu/ufmKBcLqZJH4vbmQBqWID
	6ti99yIzSEJEoJVRovVVFxtIQljAWWLrjn5WEJtFQFVi3Y/jYDavgLvEyf6dQDYH0AoFiTmT
	bEBMTgEPiXkLuUAqhIAqWn+tZ5/AyLOAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkgo
	fNnBuPiY1SFGAQ5GJR7eh/VXA4VYE8uKK3MPMUpwMCuJ8J5qBgrxpiRWVqUW5ccXleakFh9i
	ZOLglGpgtD++imdjLk+Dfsq2wwcdA4OPFb6McmSa9Gbm30X3/pvsXlSnI1bz5qh/d7V5vwfv
	n/mTp4m3vbOWjgwUrvWwrxL5InB1zwd9r+YpL99v9P3XeH2lvWDFrnmFLRbm7MuDVpt7xzk6
	fatffu1a88Swg6UXjWeK7l/4TzSU0aGS39DNv0/i6n9PJZbijERDLeai4kQAsTI/0OMBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Krivyakin <k.krivyakin@samsung.com>
---
 drivers/cpufreq/cpufreq.c |   17 +++++++++++++++++
 include/linux/cpufreq.h   |    6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6a015ad..4180e89 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1538,6 +1538,23 @@ int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list)
 }
 EXPORT_SYMBOL(cpufreq_unregister_notifier);
 
+/**
+ * cpu_power_get - get current CPU power
+ * @cpu: CPU number
+ */
+u64 cpu_power_get(int cpu)
+{
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	u64 ret_power = 0;
+
+	if (policy) {
+		ret_power = policy->current_power;
+		cpufreq_cpu_put(policy);
+	}
+
+	return ret_power;
+}
+EXPORT_SYMBOL(cpu_power_get);
 
 /*********************************************************************
  *                              GOVERNORS                            *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4d7390b..67323af 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,7 @@ struct cpufreq_policy {
 	unsigned int		max;    /* in kHz */
 	unsigned int		cur;    /* in kHz, only needed if cpufreq
 					 * governors are used */
+	u64			current_power;
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
@@ -365,6 +366,7 @@ static inline unsigned int cpufreq_get(unsigned int cpu)
 #ifdef CONFIG_CPU_FREQ
 unsigned int cpufreq_quick_get(unsigned int cpu);
 unsigned int cpufreq_quick_get_max(unsigned int cpu);
+u64 cpu_power_get(int cpu);
 #else
 static inline unsigned int cpufreq_quick_get(unsigned int cpu)
 {
@@ -374,6 +376,10 @@ static inline unsigned int cpufreq_quick_get_max(unsigned int cpu)
 {
 	return 0;
 }
+static inline u64 cpu_power_get(unsigned int cpu)
+{
+	return 0;
+}
 #endif
 
 /*********************************************************************
-- 
1.7.9.5

