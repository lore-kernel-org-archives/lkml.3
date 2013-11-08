Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab3KHWML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:12:11 -0500
Received: from ring0.de ([91.143.88.219]:60261 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294Ab3KHWMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:12:01 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: iki.fi]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv7 3/4] Input: twl4030-pwrbutton: use dev_err for errors
Date: Fri,  8 Nov 2013 23:11:26 +0100
Message-Id: <1383948687-32279-4-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383948687-32279-1-git-send-email-sre@debian.org>
References: <1383948687-32279-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_err() to output errors instead of dev_dbg().

Signed-off-by: Sebastian Reichel <sre@debian.org>
Reviewed-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/input/misc/twl4030-pwrbutton.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index a3a0fe3..48639ff 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
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

