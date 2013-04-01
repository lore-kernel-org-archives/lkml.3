Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab3DAIZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 04:25:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33536 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3DAIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 04:25:05 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-42-515944609f01
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RFC PATCH 1/2] cpuidle: Add idle enter/exit time stamp for notifying
 current idle state.
Date: Mon, 01 Apr 2013 17:24:16 +0900
Message-id: <1364804657-16590-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zPd0El8hAg1O7+C2eNv1gt7j+5Tmr
	RefZJ8wWZ5vesFu8ebiZ0eLyrjlsFp97jzBarD1yl93iduMKNov+hb1MFjMmv2Rz4Pbo27KK
	0ePR4hZGj8+b5AKYo7hsUlJzMstSi/TtErgy9i1+xlwwga+ibdsK1gbGY9xdjJwcEgImEus3
	vWeDsMUkLtxbD2RzcQgJLGOUOD//IwtMUVvnfiaIxHRGia8X10FVtTBJnFnVwwhSxSagI/F/
	3012EFtEQFViy5P/7CBFzAK3mSSO958GKuLgEBZIkfizTBikhgWoZs3u/cwgYV4BD4kDzQ4g
	poSAgsScSTYgFZwCnhKv1/8EqxACqth8xwBkoITAKnaJ/7t+MkFMEZD4NvkQC0SrrMSmA8wQ
	J0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCFh37+D8e4B60OMyUDj
	JjJLiSbnA+MmryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2MNYtFbh1nE4rOeNBjNtfdaqn74vcqb4RyeP/IMJ8x5Tq6I+TiCXYbGbbe26sa557u
	3vz4k6nKLe/qj92Sq5Zu2CR9aGWhxZ8zsyda5emeTC+/W6DbvHUFb75363u5gKcRgasshA49
	M7/SqaopfiOD7f7Xyay/y45Uvd72LI/ln8+ajPj/r50nKLEUZyQaajEXFScCAJQ0kfuRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd0El8hAg6NLuCyeNv1gt7j+5Tmr
	RefZJ8wWZ5vesFu8ebiZ0eLyrjlsFp97jzBarD1yl93iduMKNov+hb1MFjMmv2Rz4Pbo27KK
	0ePR4hZGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
	lVx8AnTdMnOALlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZuxb/Iy5
	YAJfRdu2FawNjMe4uxg5OSQETCTaOvczQdhiEhfurWfrYuTiEBKYzijx9eI6KKeFSeLMqh5G
	kCo2AR2J//tusoPYIgKqElue/GcHKWIWuM0kcbz/NFARB4ewQIrEn2XCIDUsQDVrdu9nBgnz
	CnhIHGh2ADElBBQk5kyyAangFPCUeL3+J1iFEFDF5jsGExh5FzAyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIjqpnUjsYVzZYHGIU4GBU4uGNuBARKMSaWFZcmXuIUYKDWUmE1+cbUIg3
	JbGyKrUoP76oNCe1+BBjMtBJE5mlRJPzgRGfVxJvaGxiZmRpZGZsYm5sTJqwkjjvgVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2MjA03rzJcMGRl2hJ09Y1y5erjn1fHMfs/yE/6u+540qrZ25jn
	Xst42/b826KU5BreqdMPeV9L1Y+rjd1tPXnzRJXLfWVcfL5+FRsNKo2/yW/9yd11wtI3oLHp
	Z9uJJ2znezpeMnzl+fWo7OYFLaX1lx2Mp0zKCowoLunvXBosclzSSW9TSsQcJZbijERDLeai
	4kQAZW0jfe4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds idle state time stamp to cpuidle device structure to
notify its current idle state. If last enter time is newer than last
exit time, then it means that the core is in idle now.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/cpuidle/cpuidle.c |    8 ++++----
 include/linux/cpuidle.h   |    4 ++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index eba6929..1e830cc 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -233,18 +233,18 @@ int cpuidle_wrap_enter(struct cpuidle_device *dev,
 				int (*enter)(struct cpuidle_device *dev,
 					struct cpuidle_driver *drv, int index))
 {
-	ktime_t time_start, time_end;
 	s64 diff;
 
-	time_start = ktime_get();
+	dev->last_idle_start = ktime_get();
 
 	index = enter(dev, drv, index);
 
-	time_end = ktime_get();
+	dev->last_idle_end = ktime_get();
 
 	local_irq_enable();
 
-	diff = ktime_to_us(ktime_sub(time_end, time_start));
+	diff = ktime_to_us(ktime_sub(dev->last_idle_end,
+				dev->last_idle_start));
 	if (diff > INT_MAX)
 		diff = INT_MAX;
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 480c14d..d1af05f 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/completion.h>
 #include <linux/hrtimer.h>
+#include <linux/ktime.h>
 
 #define CPUIDLE_STATE_MAX	8
 #define CPUIDLE_NAME_LEN	16
@@ -74,6 +75,9 @@ struct cpuidle_device {
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 
+	ktime_t			last_idle_start;
+	ktime_t			last_idle_end;
+
 #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
 	int			safe_state_index;
 	cpumask_t		coupled_cpus;
-- 
1.7.9.5

