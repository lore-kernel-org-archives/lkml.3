Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077Ab3ECOIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:08:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10024 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762889Ab3ECOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:08:04 -0400
X-AuditID: cbfee691-b7fe56d000004b96-bc-5183c4c094c6
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocky" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [RFC v2 3/3] cpufreq:LAB: Modify cpufreq_governor to support LAB
 Governor
Date: Fri, 03 May 2013 23:07:52 +0900
Message-id: <1367590072-10496-4-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkRPfAkeZAg+VfdC2eNv1gt5j3Wdbi
	zcPNjBaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA6XHn2h42j74tqxg9Hi1uYfT4
	vEkugCWKyyYlNSezLLVI3y6BK+Pv3iXsBesFKtZ/v8PawHiBt4uRk0NCwERi1vF/jBC2mMSF
	e+vZuhi5OIQEljJKnH37hxGmaO7jh1CJRYwSa46tZ4JwWpgkdrdOZgWpYhPQkfi/7yY7iC0i
	oCCxufcZK0gRs8A2JokZnyYzgSSEBUIkVuxYwgZiswioSuxqO8bSxcjBwSvgITHtQjSIKQHU
	O2eSDUgFp4CnxNY9q1hAbCGgiq6GlYwgIyUElrFLPFp5BmqMgMS3yYdYIHplJTYdYIY4WlLi
	4IobLBMYhRcwMqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECAz20/+eTdzBeP+A9SHGZKBx
	E5mlRJPzgdGSVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQZGDub0PFkW9954cZ5/FWemKonKLQu4vVOk7v5mkZrsnJ1iqZO99eI19Pm1zWxTHUMM
	suynG++rZRK46rl+k85HGamj7Mf+1TdMD75zNLpHTs7bYudF/SUVny59tDecr3HRcFeg+Pmf
	yz85Hpp1NZ19//cDvaqbHyvOD9HZFuq7/bpQ9gqG0nYlluKMREMt5qLiRAAeydHQjAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAd0DR5oDDWa8ULV42vSD3WLeZ1mL
	Nw83M1pc3jWHzeJz7xFGi9uNK9gs+hf2Mll0HPnGbLHxq4cDp8eda3vYPPq2rGL0eLS4hdHj
	8ya5AJaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfM
	HKBTlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZf/cuYS9YL1Cx/vsd
	1gbGC7xdjJwcEgImEnMfP2SDsMUkLtxbD2RzcQgJLGKUWHNsPROE08Iksbt1MitIFZuAjsT/
	fTfZQWwRAQWJzb3PWEGKmAW2MUnM+DSZCSQhLBAisWLHErCxLAKqErvajrF0MXJw8Ap4SEy7
	EA1iSgD1zplkA1LBKeApsXXPKhYQWwiooqthJeMERt4FjAyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYJj6ZnUDsaVDRaHGAU4GJV4eBVamgKFWBPLiitzDzFKcDArifBmNDYHCvGmJFZW
	pRblxxeV5qQWH2JMBrppIrOUaHI+MM7zSuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliS
	mp2aWpBaBLOFiYNTqoFRaurZ2319l34KzDTRVbiw5b2agPvqJql7rDu6/vPONLPpF0lcvO/5
	i5l5G7hE78y1UvM8s4bjVsT6t2czS77pXD0uXftNMr7QZpPqHe1c/6lyVxgnnXh/60TUf9Yn
	s9iW3n4uHVxw6qBB3YIJMp5fRFiEfzxv4XDPeyt9nMGUT/bhgbe9RsKtSizFGYmGWsxFxYkA
	T3yL6ukCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukasz Majewski <l.majewski@samsung.com>

Store idle_time information at newly created, per CPU struct lb_cpu_dbs_info_s
Moreover new governor #define - GOV_LAB has been added

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/cpufreq/cpufreq_governor.c |    7 +++++++
 drivers/cpufreq/cpufreq_governor.h |   15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 443442d..ab34edf 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -143,6 +143,13 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
+		if (dbs_data->governor == GOV_LAB) {
+			struct lb_cpu_dbs_info_s *lb_dbs_info =
+				dbs_data->get_cpu_dbs_info_s(j);
+
+			lb_dbs_info->idle_time = (100 * idle_time) / wall_time;
+		}
+
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 8ac3353..6bf7dcb 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -163,6 +163,20 @@ struct cs_cpu_dbs_info_s {
 	unsigned int enable:1;
 };
 
+struct lb_cpu_dbs_info_s {
+	struct cpu_dbs_common_info cdbs;
+	u64 prev_cpu_iowait;
+	struct cpufreq_frequency_table *freq_table;
+	unsigned int freq_lo;
+	unsigned int freq_lo_jiffies;
+	unsigned int freq_hi_jiffies;
+	unsigned int rate_mult;
+	unsigned int sample_type:1;
+
+	unsigned int last_sampling_rate;
+	unsigned int idle_time;
+};
+
 /* Per policy Governers sysfs tunables */
 struct od_dbs_tuners {
 	unsigned int ignore_nice;
@@ -189,6 +203,7 @@ struct common_dbs_data {
 	/* Common across governors */
 	#define GOV_ONDEMAND		0
 	#define GOV_CONSERVATIVE	1
+	#define GOV_LAB			2
 	int governor;
 	struct attribute_group *attr_group_gov_sys; /* one governor - system */
 	struct attribute_group *attr_group_gov_pol; /* one governor - policy */
-- 
1.7.9.5

