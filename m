Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbaIEOf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:35:29 -0400
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:45729 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbaIEOf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:35:28 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 10:35:27 EDT
From: =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: =?utf-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
Subject: [PATCHv3 1/4] ARM: at91/tclib: prefer using of devm_* functions
Date: Fri,  5 Sep 2014 16:14:37 +0200
Message-Id: <1409926480-16367-2-git-send-email-gael.portay@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409926480-16367-1-git-send-email-gael.portay@gmail.com>
References: <1409926480-16367-1-git-send-email-gael.portay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14234471048590621957
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrudejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejgedrudejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/misc/atmel_tclib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
index c8d8e38..b514a2d 100644
--- a/drivers/misc/atmel_tclib.c
+++ b/drivers/misc/atmel_tclib.c
@@ -150,17 +150,15 @@ static int __init tc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -EINVAL;
 
-	tc = kzalloc(sizeof(struct atmel_tc), GFP_KERNEL);
+	tc = devm_kzalloc(&pdev->dev, sizeof(struct atmel_tc), GFP_KERNEL);
 	if (!tc)
 		return -ENOMEM;
 
 	tc->pdev = pdev;
 
-	clk = clk_get(&pdev->dev, "t0_clk");
-	if (IS_ERR(clk)) {
-		kfree(tc);
-		return -EINVAL;
-	}
+	clk = devm_clk_get(&pdev->dev, "t0_clk");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 
 	/* Now take SoC information if available */
 	if (pdev->dev.of_node) {
@@ -171,10 +169,10 @@ static int __init tc_probe(struct platform_device *pdev)
 	}
 
 	tc->clk[0] = clk;
-	tc->clk[1] = clk_get(&pdev->dev, "t1_clk");
+	tc->clk[1] = devm_clk_get(&pdev->dev, "t1_clk");
 	if (IS_ERR(tc->clk[1]))
 		tc->clk[1] = clk;
-	tc->clk[2] = clk_get(&pdev->dev, "t2_clk");
+	tc->clk[2] = devm_clk_get(&pdev->dev, "t2_clk");
 	if (IS_ERR(tc->clk[2]))
 		tc->clk[2] = clk;
 
-- 
1.9.3

