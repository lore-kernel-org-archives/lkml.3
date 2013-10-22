Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3JVMzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:55:17 -0400
Received: from ring0.de ([91.143.88.219]:36078 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab3JVMzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:55:10 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org
Cc: =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCH 2/4] Input: twl4030-pwrbutton: use dev_err for errors
Date: Tue, 22 Oct 2013 14:55:02 +0200
Message-Id: <1382446504-27837-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382446504-27837-1-git-send-email-sre@debian.org>
References: <1382446504-27837-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_err() to output errors instead of dev_dbg().

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/input/misc/twl4030-pwrbutton.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index e450947..4e7a810 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -60,7 +60,7 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
 
 	pwr = input_allocate_device();
 	if (!pwr) {
-		dev_dbg(&pdev->dev, "Can't allocate power button\n");
+		dev_err(&pdev->dev, "Can't allocate power button\n");
 		return -ENOMEM;
 	}
 
@@ -74,13 +74,13 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			"twl4030_pwrbutton", pwr);
 	if (err < 0) {
-		dev_dbg(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
+		dev_err(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
 		goto free_input_dev;
 	}
 
 	err = input_register_device(pwr);
 	if (err) {
-		dev_dbg(&pdev->dev, "Can't register power button: %d\n", err);
+		dev_err(&pdev->dev, "Can't register power button: %d\n", err);
 		goto free_irq;
 	}
 
-- 
1.8.4.rc3

