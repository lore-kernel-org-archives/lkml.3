Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3EMIdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:33:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30403 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3EMIdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:33:24 -0400
X-AuditID: cbfee691-b7fef6d000002d62-14-5190a552b00f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com
Subject: [PATCH] sched: Add nr_running_cpu() to get current of running threads
 of each core
Date: Mon, 13 May 2013 17:33:12 +0900
Message-id: <1368433992-19162-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkSDdo6YRAg/s/VC2uf3nOanG26Q27
	xeVdc9gsLh1YwGRxu3EFm8Xx3gNMDmwem1doebzfd5XNo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDIWt81hLnjNXXHr1iyWBsa3nF2MnBwSAiYSp6fOZoKwxSQu3FvP1sXIxSEksJRR4v+9
	R0wwRfMevmeBSExnlOhecx2q6j+jxMGuo8wgVWwCWhL7X9xgA7FFgOxJC8+B2cwCeRI9+6ew
	gtjCArESK/dvZASxWQRUJRZP3Qlm8wq4SvQfmscOsU1O4sOeR+wgCyQEXrNJNKw5xQbRICDx
	bfIhoDM4gBKyEpsOMEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsY
	gSF6+t+ziTsY7x+wPsSYDDRuIrOUaHI+MMTzSuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cDI02MnosJWeOX+9+zfnI8Ynq+R09Gdcum91rLa6zmP
	dJX5zdzciq8GrHZ62Fp252D2ZmlbE9/lU01vn7l94YX0jXf2+lm2exm1M8LWLjmVp1W0VO6O
	cvlX+fTLW9q047snX+lkNt5wVK5t/WOuvd+qraKaVq08Mo/1h/XzjStryu+wPp40T1tXiaU4
	I9FQi7moOBEA+QYp0GcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQd2gpRMCDY6skrO4/uU5q8XZpjfs
	Fpd3zWGzuHRgAZPF7cYVbBbHew8wObB5bF6h5fF+31U2j74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWNw2h7ngNXfFrVuzWBoY33J2MXJySAiYSMx7
	+J4FwhaTuHBvPVsXIxeHkMB0RonuNdehnP+MEge7jjKDVLEJaEnsf3GDDcQWAbInLTwHZjML
	5En07J/CCmILC8RKrNy/kRHEZhFQlVg8dSeYzSvgKtF/aB47xDY5iQ97HrFPYORewMiwilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Ap5J7WBc2WBxiFGAg1GJh3eB8oRAIdbEsuLK3EOM
	EhzMSiK8SfOBQrwpiZVVqUX58UWlOanFhxiTgbZPZJYSTc4HRmdeSbyhsYmZkaWRuaGFkbE5
	acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTDGhbOWK+/4ebypTsXe6J2bZMjCRvU1k4t+
	215T6pzQcp3nstKz2O5vIVo9nNHrj2w5Hv9c0MxYaburVdbJ0hd8FapJzq8//OV2NdfUD5vC
	fW1C1qzk5phSYQM9VZ8ygx0sd4p+/PihvEGvaOuO0K2fDF/lbVdsKC5oWCT4NVAiKEarxu+9
	uhJLcUaioRZzUXEiAE/h+PbEAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add nr_running_cpu() function to get current
number of running threads of each core.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 include/linux/sched.h | 1 +
 kernel/sched/core.c   | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..98b7917 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -99,6 +99,7 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
+extern unsigned long nr_running_cpu(int cpu);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..4052dc8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2014,7 +2014,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 }
 
 /*
- * nr_running and nr_context_switches:
+ * nr_running, nr_running_cpu and nr_context_switches:
  *
  * externally visible scheduler statistics: current number of runnable
  * threads, total number of context switches performed since bootup.
@@ -2029,6 +2029,12 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+unsigned long nr_running_cpu(int cpu)
+{
+	struct rq *this = cpu_rq(cpu);
+	return this->nr_running;
+}
+
 unsigned long long nr_context_switches(void)
 {
 	int i;
-- 
1.8.0

