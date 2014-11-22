Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaKVNL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 08:11:28 -0500
Received: from mout.web.de ([212.227.15.3]:63918 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaKVNL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 08:11:27 -0500
Message-ID: <54708B5E.2080302@users.sourceforge.net>
Date: Sat, 22 Nov 2014 14:10:54 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] x86: AMD-perf_event: Deletion of unnecessary checks before
 the function call "free_percpu"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Mil20yIHZvxyZiu4bXPfK/cJAyy/Okqpc37U8VCcP4Vz4HAwqyC
 D9NVkEjl5ctDO6yw61pbFLO61O6GOfE0OaWQ2Sb/i95SJ0hDeJD1B9sc4o9Hw2ZKp2f9qB1
 1vyzrndVh9wKJ0ZIpQgSbj1K4tZpWiuvcbC/Z2PtMZyKoG9HCsicaFlDb8QcWmJUkRhYouA
 hS1k2XC1Uad8ZEgD5m+Bw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Nov 2014 14:01:27 +0100

The free_percpu() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 arch/x86/kernel/cpu/perf_event_amd_uncore.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index 30790d7..4856232 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -592,11 +592,9 @@ fail_online:
 fail_l2:
 	if (cpu_has_perfctr_nb)
 		perf_pmu_unregister(&amd_nb_pmu);
-	if (amd_uncore_l2)
-		free_percpu(amd_uncore_l2);
+	free_percpu(amd_uncore_l2);
 fail_nb:
-	if (amd_uncore_nb)
-		free_percpu(amd_uncore_nb);
+	free_percpu(amd_uncore_nb);
 
 fail_nodev:
 	return ret;
-- 
2.1.3

