Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3LOX2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:28:32 -0500
Received: from ring0.de ([91.143.88.219]:40060 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab3LOX21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:28:27 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 02/11] HSI: hsi-char: add Device Tree support
Date: Mon, 16 Dec 2013 00:27:55 +0100
Message-Id: <1387150085-23173-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387150085-23173-1-git-send-email-sre@debian.org>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_match_table to hsi_char driver, so that it can
be referenced from Device Tree.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/hsi/clients/hsi_char.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/hsi/clients/hsi_char.c b/drivers/hsi/clients/hsi_char.c
index e61e5f9..7f64bed 100644
--- a/drivers/hsi/clients/hsi_char.c
+++ b/drivers/hsi/clients/hsi_char.c
@@ -42,6 +42,7 @@
 #include <linux/stat.h>
 #include <linux/hsi/hsi.h>
 #include <linux/hsi/hsi_char.h>
+#include <linux/of_device.h>
 
 #define HSC_DEVS		16 /* Num of channels */
 #define HSC_MSGS		4
@@ -758,12 +759,22 @@ static int hsc_remove(struct device *dev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id hsi_char_of_match[] = {
+	{ .compatible = "ssi-char", },
+	{ .compatible = "hsi-char", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, hsi_char_of_match);
+#endif
+
 static struct hsi_client_driver hsc_driver = {
 	.driver = {
 		.name	= "hsi_char",
 		.owner	= THIS_MODULE,
 		.probe	= hsc_probe,
 		.remove	= hsc_remove,
+		.of_match_table = of_match_ptr(hsi_char_of_match),
 	},
 };
 
-- 
1.8.5.1

