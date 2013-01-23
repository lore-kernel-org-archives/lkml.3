Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AWIHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:07:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40024 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab3AWIHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:07:19 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] leds-lp5523: fix a build warning
Thread-Topic: [PATCH 2/2] leds-lp5523: fix a build warning
Thread-Index: Ac35QKbWaFrZStdpQ8yGFLQF8NVWUw==
Date: Wed, 23 Jan 2013 08:07:13 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1C285@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clears a build warning below.(ARCH=x86_64)

drivers/leds/leds-lp5523.c: In function lp5523_firmware_loaded:
drivers/leds/leds-lp5523.c:283:4: warning: format %d expects argument of type in
t, but argument 3 has type size_t [-Wformat]

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5523.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 4ac7061..0181ea6 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -279,7 +279,7 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
 	const struct firmware *fw = chip->fw;
 
 	if (fw->size > LP5523_PROGRAM_LENGTH) {
-		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
+		dev_err(&chip->cl->dev, "firmware data size overflow: %zd\n",
 			fw->size);
 		return;
 	}
-- 
1.7.9.5


Best Regards,
Milo


