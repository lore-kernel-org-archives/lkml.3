Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3AWIHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:07:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33355 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab3AWIHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:07:19 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] leds-lp5521: fix a build warning
Thread-Topic: [PATCH 1/2] leds-lp5521: fix a build warning
Thread-Index: Ac35QKQ6hqr/3pYRTG+j+CD6o7gucg==
Date: Wed, 23 Jan 2013 08:07:09 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1C27D@DQHE02.ent.ti.com>
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

This patch removes a build warning below.(ARCH=x86_64)

drivers/leds/leds-lp5521.c: In function lp5521_firmware_loaded:
drivers/leds/leds-lp5521.c:257:4: warning: format %d expects argument of type in
t, but argument 3 has type size_t [-Wformat]

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 80adfb4..74946f4 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -253,7 +253,7 @@ static void lp5521_firmware_loaded(struct lp55xx_chip *chip)
 	const struct firmware *fw = chip->fw;
 
 	if (fw->size > LP5521_PROGRAM_LENGTH) {
-		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
+		dev_err(&chip->cl->dev, "firmware data size overflow: %zd\n",
 			fw->size);
 		return;
 	}
-- 
1.7.9.5


Best Regards,
Milo


