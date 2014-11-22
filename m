Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaKVKBM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 05:01:12 -0500
Received: from mout.web.de ([212.227.15.14]:59686 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaKVKBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 05:01:09 -0500
Message-ID: <54705EC3.90708@users.sourceforge.net>
Date: Sat, 22 Nov 2014 11:00:35 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] ARM: OMAP2: Deletion of unnecessary checks before three
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:V3YV+Ku7FF3kLCTBH1YUV23cgqVNCaII9lgI9JE5PQ5YjpXn6Wf
 I47PaUdYn8otHP0q08KjsrlDzawpNhE6Iqt6gLPp8AWs2yRjPNm+sCxJEzneS2ahRnF+hkO
 NmEcq0tVPCM0OdP13UtcXsdjmguYRh2x76hx3RnBc/LhYHzecpK6crUtlE3iZyW1aLc9KFe
 7MK8hDvnZ5XxF7K58YY8g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Nov 2014 10:50:33 +0100

The functions clk_disable(), of_node_put() and omap_device_delete() test
whether their argument is NULL and then return immediately.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 arch/arm/mach-omap2/omap_device.c | 3 +--
 arch/arm/mach-omap2/omap_hwmod.c  | 3 +--
 arch/arm/mach-omap2/timer.c       | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index d22c30d..5108859 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -199,8 +199,7 @@ static int _omap_device_notifier_call(struct notifier_block *nb,
 
 	switch (event) {
 	case BUS_NOTIFY_DEL_DEVICE:
-		if (pdev->archdata.od)
-			omap_device_delete(pdev->archdata.od);
+		omap_device_delete(pdev->archdata.od);
 		break;
 	case BUS_NOTIFY_ADD_DEVICE:
 		if (pdev->dev.of_node)
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 9e91a4e..e2406c4 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -917,8 +917,7 @@ static int _disable_clocks(struct omap_hwmod *oh)
 
 	pr_debug("omap_hwmod: %s: disabling clocks\n", oh->name);
 
-	if (oh->_clk)
-		clk_disable(oh->_clk);
+	clk_disable(oh->_clk);
 
 	p = oh->slave_ports.next;
 
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 43d03fb..5b428a0 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -205,8 +205,7 @@ static void __init omap_dmtimer_init(void)
 	/* If we are a secure device, remove any secure timer nodes */
 	if ((omap_type() != OMAP2_DEVICE_TYPE_GP)) {
 		np = omap_get_timer_dt(omap_timer_match, "ti,timer-secure");
-		if (np)
-			of_node_put(np);
+		of_node_put(np);
 	}
 }
 
-- 
2.1.3

