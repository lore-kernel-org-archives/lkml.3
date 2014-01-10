Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaAJPBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:01:15 -0500
Received: from mail1.windriver.com ([147.11.146.13]:54745 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAJPBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:01:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: [PATCH] s390: delete new instances of __cpuinit usage
Date: Fri, 10 Jan 2014 10:00:50 -0500
Message-ID: <1389366050-25210-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8c069ff4bd6063a3f15e606c882e03f75c7e7711 ("s390/perf: add
support for the CPU-Measurement Sampling Facility") added a new
instance of the __cpuinit macro usage.

We removed this a couple versions ago; we now want to remove
the compat no-op stubs.  Introducing new users is not what
we want to see at this point in time, as it will break once
the stubs are gone.

Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Patch based on today's linux-next tree, so if s390 next content
 gets rebased, then the above commit ID will be invalidated; if it
 _does_ get rebased, then feel free to squash this fix into the orig.]

 arch/s390/kernel/perf_cpum_sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 3c3bc8d7b220..ce3a1d9c521b 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1512,7 +1512,7 @@ static void cpumf_measurement_alert(struct ext_code ext_code,
 	}
 }
 
-static int __cpuinit cpumf_pmu_notifier(struct notifier_block *self,
+static int cpumf_pmu_notifier(struct notifier_block *self,
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long) hcpu;
-- 
1.8.5.2

