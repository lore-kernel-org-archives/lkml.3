Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaATLgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:36:11 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:9536
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaATLgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:36:08 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzdchz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h1155h)
From: Robin Gong <b38343@freescale.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <cooloney@gmail.com>, <rpurdie@rpsys.net>,
        <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v1 1/2] leds: leds-gpio: add retain-state-suspended property
Date: Mon, 20 Jan 2014 19:41:26 +0800
Message-ID: <1390218087-14597-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some gpio-leds need retain the state even in suspend, such as charger led.
But this property missed in devicetree, add it.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/leds/leds-gpio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 78b0e27..1bb3f1a 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -204,6 +204,9 @@ static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 				led.default_state = LEDS_GPIO_DEFSTATE_OFF;
 		}
 
+		if (of_get_property(child, "retain-state-suspended", NULL))
+			led.retain_state_suspended = 1;
+
 		ret = create_gpio_led(&led, &priv->leds[priv->num_leds++],
 				      &pdev->dev, NULL);
 		if (ret < 0) {
-- 
1.7.5.4


