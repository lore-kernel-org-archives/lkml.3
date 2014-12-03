Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaLCIQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:16:16 -0500
Received: from mout.web.de ([212.227.15.14]:50306 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaLCIQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:16:14 -0500
Message-ID: <547EC6B8.6000001@users.sourceforge.net>
Date: Wed, 03 Dec 2014 09:15:52 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        linux-arm-kernel@lists.infradead.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] ARM: DaVinci: Deletion of an unnecessary check before the
 function call "__clk_disable"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:CYUOXTHM44OwA9itVhdhn7pFUZp50hVYxZRn9xQGfovklX1sZlM
 O5IuBPNrI9YGT5HnYkFEBvM9sNbCup+ueJmEfGg2agLQOwUVMLhFrXUcIkfo9erhs/XTQdf
 ssVKwhqHY3EvpaG/VXhilFhPTLwFcboP6s5C+4DF71tB4g3tdtpsAN9uh7o2iQyzCPwjjqr
 Vw9xIcBRpA9RliCMZYGOg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 3 Dec 2014 09:01:33 +0100

The __clk_disable() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 arch/arm/mach-davinci/clock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/clock.c b/arch/arm/mach-davinci/clock.c
index c70bb0a..8f2c2d8 100644
--- a/arch/arm/mach-davinci/clock.c
+++ b/arch/arm/mach-davinci/clock.c
@@ -55,8 +55,7 @@ static void __clk_disable(struct clk *clk)
 		else if (clk->clk_disable)
 			clk->clk_disable(clk);
 	}
-	if (clk->parent)
-		__clk_disable(clk->parent);
+	__clk_disable(clk->parent);
 }
 
 int davinci_clk_reset(struct clk *clk, bool reset)
-- 
2.1.3

