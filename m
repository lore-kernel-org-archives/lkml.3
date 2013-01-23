Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3AWXn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:43:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52404 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab3AWXnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:43:49 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: Nathan Lynch <ntl@pobox.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] leds-lp5521/3: use '%zu' for formatting 'size_t'
Thread-Topic: [PATCH v2] leds-lp5521/3: use '%zu' for formatting 'size_t'
Thread-Index: Ac35w3gJ03eEQdh5Ts6dYDQX6ucNeg==
Date: Wed, 23 Jan 2013 23:43:41 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1C4F7@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The printk format of type 'size_t' is not '%d' but '%zu' or '%zx'.
This patch fixes build warnings below.

 drivers/leds/leds-lp5521.c: In function lp5521_firmware_loaded:
 drivers/leds/leds-lp5521.c:257:4: warning: format %d expects argument of
  type int, but argument 3 has type size_t [-Wformat]

 drivers/leds/leds-lp5523.c: In function lp5523_firmware_loaded:
 drivers/leds/leds-lp5523.c:283:4: warning: format %d expects argument of
  type int, but argument 3 has type size_t [-Wformat]

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    2 +-
 drivers/leds/leds-lp5523.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 80adfb4..1001347 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -253,7 +253,7 @@ static void lp5521_firmware_loaded(struct lp55xx_chip *chip)
 	const struct firmware *fw = chip->fw;
 
 	if (fw->size > LP5521_PROGRAM_LENGTH) {
-		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
+		dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
 			fw->size);
 		return;
 	}
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 4ac7061..229f734 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -279,7 +279,7 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
 	const struct firmware *fw = chip->fw;
 
 	if (fw->size > LP5523_PROGRAM_LENGTH) {
-		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
+		dev_err(&chip->cl->dev, "firmware data size overflow: %zu\n",
 			fw->size);
 		return;
 	}
-- 
1.7.9.5


Best Regards,
Milo

