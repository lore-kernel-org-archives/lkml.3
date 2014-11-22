Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaKVKlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 05:41:44 -0500
Received: from mout.web.de ([212.227.17.11]:52165 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbaKVKlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 05:41:40 -0500
Message-ID: <54706826.7060403@users.sourceforge.net>
Date: Sat, 22 Nov 2014 11:40:38 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] ARM-kernel: Deletion of unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:UTMu2VhyeZbqpWDC08CRfgj6smk+8ubjoNdYYvwkHCncRQ1H6ba
 xqkT47SKlcdR4tVgkloz0xk09pVLqTHTo1ILw2VRg10uW3HwRMojidVck+SP6cFWKPA4jLb
 o0bHjDZhLmtgJKDWZPEAFiKtnXFnOZcpl1rjJtq10L1dHkATCxaFVXu0PL63LvqJCvfRqTJ
 SeogTXmY8Vnxv4UxRMvmg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Nov 2014 11:33:16 +0100

The functions smp_set_ops() and unwind_table_del() test whether their argument
is NULL and then return immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 arch/arm/kernel/module.c | 3 +--
 arch/arm/kernel/setup.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 6a4dffe..3dffad1 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -350,7 +350,6 @@ module_arch_cleanup(struct module *mod)
 	int i;
 
 	for (i = 0; i < ARM_SEC_MAX; i++)
-		if (mod->arch.unwind[i])
-			unwind_table_del(mod->arch.unwind[i]);
+		unwind_table_del(mod->arch.unwind[i]);
 #endif
 }
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 84db893d..a7018a2 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -929,7 +929,7 @@ void __init setup_arch(char **cmdline_p)
 		if (!mdesc->smp_init || !mdesc->smp_init()) {
 			if (psci_smp_available())
 				smp_set_ops(&psci_smp_ops);
-			else if (mdesc->smp)
+			else
 				smp_set_ops(mdesc->smp);
 		}
 		smp_init_cpus();
-- 
2.1.3

